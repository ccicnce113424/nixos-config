#!/usr/bin/env bash
set -euo pipefail

# Manifest of nixpkgs PRs whose patches are applied to nixpkgs.
# Run from the repository root via `just pr` / `nix run .#nixpkgs-prs`
# (direct execution needs curl, jq and moreutils on PATH).
manifest=nixpkgs-prs.json
output_dir=patches/nixpkgs-pr

# Patch application order is plain filename order (`lib.fileset.toList` sorts
# path components lexicographically), so every patch is named
# "<priority>-<number>.patch" with a two-digit priority: 00 <= priority <= 99
# keeps that order numeric. Files not following that scheme are ignored.
default_priority=50

pad_priority() { printf '%02d\n' "$1"; }

# Prints <priority> as a plain integer, accepting leading zeros; 0-99 only.
normalize_priority() {
  local p=$1
  if [[ ! $p =~ ^[0-9]{1,2}$ ]]; then
    echo "Invalid priority: $1 (expected an integer in 0-99)" >&2
    exit 1
  fi
  printf '%s\n' $((10#$p))
}

# Prints the priority encoded in a patch filename.
priority_of() {
  local base=${1##*/}
  if [[ $base =~ ^([0-9]{2})-[0-9]+\.(patch|diff)$ ]]; then
    printf '%s\n' $((10#${BASH_REMATCH[1]}))
  else
    printf '%s\n' "$default_priority"
  fi
}

# Sets patch_paths to every <priority>-<n>.patch|diff in the output directory.
patch_paths=()

patch_files() {
  local n=$1 f base
  patch_paths=()
  for f in "$output_dir"/*.patch "$output_dir"/*.diff; do
    [[ -e $f ]] || continue
    base=${f##*/}
    if [[ $base =~ ^[0-9]{2}-$n\.(patch|diff)$ ]]; then
      patch_paths+=("$f")
    fi
  done
}

# Prints the managed file for PR <n>; empty if absent.
patch_file() {
  local n=$1
  patch_files "$n"
  if ((${#patch_paths[@]} > 0)); then
    printf '%s\n' "${patch_paths[0]}"
  fi
}

# Prints where `download_pr` should write PR <n>: an explicit <priority>
# overrides, otherwise an existing file keeps its name (so manual renames
# survive --refresh) and everything else gets the default priority.
patch_target() {
  local n=$1 priority=${2:-}
  patch_files "$n"
  if [[ -z $priority ]] && ((${#patch_paths[@]} > 0)); then
    printf '%s\n' "${patch_paths[0]}"
    return 0
  fi
  printf '%s/%s-%s.patch\n' "$output_dir" "$(pad_priority "${priority:-$default_priority}")" "$n"
}

usage() {
  {
    echo "Usage: nixpkgs-prs [show | update | add | remove | prune] [ARGS...]"
    echo
    echo "  nixpkgs-prs               same as show (default)"
    echo "  nixpkgs-prs show          list PRs in application order: patch/PR state, priority, branch reached, links"
    echo "  nixpkgs-prs update        prune landed PRs, then apply --remove/--add"
    echo "                            options: --refresh (re-download every patch), --priority N,"
    echo "                            --remove REF, --add REF (repeatable)"
    echo "  nixpkgs-prs add REF...    add PRs to $manifest, then download their patches"
    echo "  nixpkgs-prs remove REF... remove PRs from $manifest, then delete their patches"
    echo "  nixpkgs-prs prune         drop PRs already in the nixpkgs pinned in flake.lock"
    echo
    echo "REF is a PR number or https://github.com/NixOS/nixpkgs/pull/<number>"
    echo
    echo "Patches are applied in filename order, so each one is named"
    echo "<priority>-<number>.patch with a two-digit priority (00-99, default"
    echo "$default_priority); --priority N sets it for every add that follows, and"
    echo "renaming the file reorders it. Files not in that format are ignored."
  } >&2
  exit 1
}

# Accepts a bare PR number, a pull URL, or either with a .patch/.diff suffix.
normalize_url() {
  local ref=$1
  ref="${ref%.patch}"
  ref="${ref%.diff}"
  if [[ $ref =~ ^[0-9]+$ ]]; then
    ref="https://github.com/NixOS/nixpkgs/pull/$ref"
  fi
  if [[ ! $ref =~ ^https://github\.com/NixOS/nixpkgs/pull/[0-9]+$ ]]; then
    echo "Invalid PR reference: $1" >&2
    return 1
  fi
  printf '%s\n' "$ref"
}

# Auth: $GITHUB_TOKEN first (workflow), else a logged-in gh CLI if the environment
# happens to have one (never a declared dependency), else anonymous (60 req/h --
# an exhausted quota then surfaces as "?" in `show`). Resolved once per run so `gh`
# spawns at most once; $( ) subshells inherit api_token.
api_token=""

resolve_auth() {
  if [[ -n ${GITHUB_TOKEN:-} ]]; then
    api_token=$GITHUB_TOKEN
  elif command -v gh >/dev/null 2>&1; then
    api_token=$(gh auth token 2>/dev/null || true)
  fi
}

# GET api.github.com/repos/NixOS/nixpkgs/<path>; prints nothing on failure.
api_get() {
  local path=$1
  local -a auth=()
  if [[ -n $api_token ]]; then
    auth=(-H "Authorization: Bearer $api_token")
  fi
  curl -fsSL --retry 3 --retry-all-errors "${auth[@]}" \
    "https://api.github.com/repos/NixOS/nixpkgs/$path" || true
}

# Prints "<title>\t<state>\t<head sha>\t<merge sha>"; prints nothing when the API can't say.
# The title lives here, not in the manifest: it changes over time and we ask the
# API for state anyway.
remote_status() {
  api_get "pulls/$1" |
    jq -r 'if has("state") then [(.title // "" | strings | gsub("^\\s+|\\s+$"; "")), (if .merged then "merged" elif .draft then "draft" elif .state == "open" then "open" else "closed" end), (.head.sha // ""), (.merge_commit_sha // "")] | @tsv else empty end' || true
}

# yes / no / ? -- whether <ref> contains <sha> (same as nixpkgs-tracker:
# compare branch...commit is "behind" or "identical" when the commit landed).
ref_contains() {
  local ref=$1 sha=$2
  local status
  status=$(api_get "compare/$ref...$sha" |
    jq -r 'if has("status") then (if .status == "behind" or .status == "identical" then "yes" else "no" end) else empty end' || true)
  printf '%s\n' "${status:-?}"
}

# Prints the local patch status: ok / stale / missing / ? (remote unavailable).
# Cheap path: stored head rev vs the current head rev. Without a stored rev (hand-added
# entry) or an API answer, falls back to comparing content against the remote .patch.
patch_status() {
  local url=$1 head_sha=$2
  local n="${url##*/}"
  local file
  file=$(patch_file "$n")
  if [[ -z $file ]]; then
    printf '%s\n' missing
    return 0
  fi
  local stored
  stored=$(jq -r --arg url "$url" \
    'first(.[] | select(.url == $url) | .rev // empty) // empty' "$manifest")
  if [[ -n $stored && -n $head_sha ]]; then
    if [[ $stored == "$head_sha" ]]; then
      printf '%s\n' ok
    else
      printf '%s\n' stale
    fi
    return 0
  fi
  local tmp verdict
  tmp=$(mktemp)
  if ! curl -fsSL --retry 3 --retry-all-errors --output "$tmp" "$url.patch"; then
    verdict='?'
  elif cmp -s "$tmp" "$file"; then
    verdict=ok
  else
    verdict=stale
  fi
  rm -f "$tmp"
  printf '%s\n' "$verdict"
}

# Downloads PR <n>'s patch to its canonical filename. <priority> is optional and
# overrides the filename prefix; without it an existing prefix is preserved.
download_pr() {
  local url=$1
  local n="${url##*/}"
  local rev="${2:-}" # head rev; callers that already fetched the PR pass it in
  local priority="${3:-}"
  if [[ -z $rev ]]; then
    rev=$(api_get "pulls/$n" | jq -r '.head.sha // empty | strings' || true)
  fi
  local dest f
  dest=$(patch_target "$n" "$priority")
  mkdir -p "$output_dir"
  echo "Downloading PR #$n..." >&2
  # Write via a temp file so a failed download never leaves a truncated patch.
  curl -fL --retry 5 --retry-all-errors --speed-limit 1024 --speed-time 15 \
    --output "$dest.tmp" "$url.patch"
  mv -f -- "$dest.tmp" "$dest"
  # Drop the previous priority prefix for the same PR after an explicit
  # --priority change.
  patch_files "$n"
  for f in "${patch_paths[@]}"; do
    [[ $f == "$dest" ]] || rm -f -- "$f"
  done
  # Record the head rev this patch was fetched at, so `show` can compare without
  # downloading. Captured before the patch: a race then yields a harmless false
  # "stale" instead of a false "ok".
  if [[ -n $rev ]]; then
    jq --arg url "$url" --arg rev "$rev" \
      'map(if .url == $url then .rev = $rev else . end)' "$manifest" | sponge "$manifest"
  fi
}

refresh_all() {
  local urls=() url f base n
  mapfile -t urls < <(jq -r '.[].url' "$manifest")
  for url in "${urls[@]}"; do
    # No explicit priority: download_pr reuses each file's existing prefix, so a
    # hand-renamed priority survives --refresh.
    download_pr "$url"
  done
  # Remove leftovers whose PR is no longer listed (the old implementation wiped
  # the directory up front, which also dropped every priority prefix). Only our
  # own naming scheme is managed; other files are left untouched.
  local -A wanted=()
  for url in "${urls[@]}"; do
    wanted[${url##*/}]=1
  done
  for f in "$output_dir"/*.patch "$output_dir"/*.diff; do
    [[ -e $f ]] || continue
    base=${f##*/}
    if [[ ! $base =~ ^[0-9]{2}-([0-9]+)\.(patch|diff)$ ]]; then
      continue
    fi
    n=${BASH_REMATCH[1]}
    if [[ -z ${wanted[$n]:-} ]]; then
      echo "Removing stale patch: $f" >&2
      rm -f -- "$f"
    fi
  done
}

# --priority N is sticky: it applies to every REF that follows it, so both
# `add --priority 10 123` and `add 123 --priority 10 456` work.
cmd_add() {
  if (($# == 0)); then usage; fi
  local ref url n rev priority="" added=0
  while (($# > 0)); do
    case "$1" in
    --priority)
      if (($# < 2)); then usage; fi
      priority=$(normalize_priority "$2")
      shift 2
      ;;
    *)
      ref=$1
      shift
      url=$(normalize_url "$ref")
      n="${url##*/}"
      rev=""
      if jq -e --arg url "$url" 'any(.[]; .url == $url)' "$manifest" >/dev/null; then
        echo "PR #$n is already in $manifest" >&2
      else
        # The head rev doubles as an existence check: nothing is written when the
        # PR cannot be fetched (404 / rate limit).
        rev=$(api_get "pulls/$n" | jq -r '.head.sha // empty | strings' || true)
        if [[ -z $rev ]]; then
          echo "Failed to fetch PR #$n" >&2
          exit 1
        fi
        jq --arg url "$url" --arg rev "$rev" \
          '. + [{ url: $url, rev: $rev }]' "$manifest" | sponge "$manifest"
        echo "Added PR #$n to $manifest" >&2
      fi
      download_pr "$url" "$rev" "$priority"
      added=$((added + 1))
      ;;
    esac
  done
  ((added > 0)) || usage
}

cmd_remove() {
  if (($# == 0)); then usage; fi
  local ref url n
  for ref in "$@"; do
    url=$(normalize_url "$ref")
    n="${url##*/}"
    if jq -e --arg url "$url" 'any(.[]; .url == $url)' "$manifest" >/dev/null; then
      jq --arg url "$url" 'map(select(.url != $url))' "$manifest" | sponge "$manifest"
      echo "Removed PR #$n from $manifest" >&2
    else
      echo "PR #$n is not in $manifest" >&2
    fi
    patch_files "$n"
    if ((${#patch_paths[@]} > 0)); then
      rm -f -- "${patch_paths[@]}"
    fi
  done
}

# Drops PRs whose merge commit is already in the nixpkgs revision pinned in flake.lock.
cmd_prune() {
  local pin
  # Two-layer lookup like default.nix does for flake-compat: resolve the node via
  # root.inputs (no hardcoded node name), prefer the recorded rev, else parse it
  # out of the versioned release URL; fail when neither exists.
  pin=$(jq -r '.nodes[(.nodes.root.inputs.nixpkgs // "nixpkgs")].locked
    | .rev // ((.url // "") | capture("nixos-[^/]*\\.(?<rev>[0-9a-f]{12})/")? | .rev)
    // empty' flake.lock 2>/dev/null || true)
  if [[ -z $pin ]]; then
    echo "Cannot determine the nixpkgs revision pinned in flake.lock" >&2
    return 1
  fi
  local url n info state rest merge_sha
  local -a drop=()
  while IFS= read -r url; do
    n="${url##*/}"
    state=""
    merge_sha=""
    info=$(remote_status "$n")
    if [[ -n $info ]]; then
      rest=${info#*$'\t'}
      state=${rest%%$'\t'*}
      merge_sha=${info##*$'\t'}
    fi
    if [[ $state == merged && -n $merge_sha ]] &&
      [[ $(ref_contains "$pin" "$merge_sha") == yes ]]; then
      echo "PR #$n landed in nixpkgs $pin" >&2
      drop+=("$url")
    fi
  done < <(jq -r '.[].url' "$manifest")

  if (("${#drop[@]}" == 0)); then
    echo "No PRs have landed in the pinned nixpkgs ($pin)" >&2
    return 0
  fi
  for url in "${drop[@]}"; do
    jq --arg url "$url" 'map(select(.url != $url))' "$manifest" | sponge "$manifest"
    patch_files "${url##*/}"
    if ((${#patch_paths[@]} > 0)); then
      rm -f -- "${patch_paths[@]}"
    fi
  done
  echo "Dropped ${#drop[@]} PR(s) already in the pinned nixpkgs" >&2
}

cmd_show() {
  if (($(jq 'length' "$manifest") == 0)); then
    echo "No PRs listed in $manifest"
    return 0
  fi
  local n url title info state head_sha merge_sha patch_state tracker reached file priority
  local rest r_unstable r_small r_master
  # Patches are applied in filename order, so list the PRs the same way:
  # priority first, then PR number.
  local rows name
  rows=$(
    jq -r '.[].url' "$manifest" | while IFS= read -r url; do
      n=${url##*/}
      # Sort by the actual filename: that is exactly the order they are applied in.
      file=$(patch_file "$n")
      printf '%s\t%s\n' "${file:-$(pad_priority "$default_priority")-$n.patch}" "$url"
    done | sort -t $'\t' -k1,1
  )
  while IFS=$'\t' read -r name url; do
    n="${url##*/}"
    priority=$(priority_of "$name")
    title=""
    state=""
    head_sha=""
    merge_sha=""
    tracker=""
    reached=""
    info=$(remote_status "$n")
    if [[ -n $info ]]; then
      title=${info%%$'\t'*}
      rest=${info#*$'\t'}
      state=${rest%%$'\t'*}
      rest=${rest#*$'\t'}
      head_sha=${rest%%$'\t'*}
      merge_sha=${rest#*$'\t'}
    fi
    patch_state=$(patch_status "$url" "$head_sha")
    if [[ $state == merged ]]; then
      tracker="https://nixpk.gs/pr-tracker.html?pr=$n"
      if [[ -n $merge_sha ]]; then
        # Linear constraint: master -> nixos-unstable-small -> nixos-unstable.
        # Ask furthest first and stop at the first hit -- it implies all earlier
        # stages, so a fully landed PR costs one compare instead of three.
        r_unstable=$(ref_contains nixos-unstable "$merge_sha")
        if [[ $r_unstable == yes ]]; then
          reached=nixos-unstable
        else
          r_small=$(ref_contains nixos-unstable-small "$merge_sha")
          if [[ $r_small == yes ]]; then
            reached=nixos-unstable-small
          else
            r_master=$(ref_contains master "$merge_sha")
            if [[ $r_master == yes ]]; then
              reached=master
            elif [[ $r_unstable == "?" || $r_small == "?" || $r_master == "?" ]]; then
              reached="?"
            else
              reached=none
            fi
          fi
        fi
      else
        reached="?"
      fi
    fi
    printf '#%s%s\n' "$n" "${title:+  $title}"
    printf '  %-9s %s\n' 'patch:' "$patch_state"
    printf '  %-9s %s\n' 'priority:' "$(pad_priority "$priority")"
    printf '  %-9s %s\n' 'pr:' "${state:-?}"
    if [[ -n $reached ]]; then
      printf '  %-9s %s\n' 'in:' "$reached"
    fi
    printf '  %-9s %s\n' 'link:' "$url"
    if [[ -n $tracker ]]; then
      printf '  %-9s %s\n' 'tracker:' "$tracker"
    fi
    echo
  done <<<"$rows"
}

if [[ ! -f $manifest ]]; then
  echo "Manifest not found: $manifest (run this from the repository root)" >&2
  exit 1
fi
if ! jq -e 'type == "array" and all(.[]; type == "object" and has("url"))' "$manifest" >/dev/null; then
  echo "Invalid manifest: $manifest (expected a list of {url} objects)" >&2
  exit 1
fi

resolve_auth

case "${1:-}" in
"" | show)
  cmd_show
  ;;
update)
  shift
  do_refresh=false
  removes=()
  adds=()
  add_priority=""
  while (($# > 0)); do
    case "$1" in
    --refresh)
      do_refresh=true
      shift
      ;;
    --priority)
      if (($# < 2)); then usage; fi
      add_priority=$(normalize_priority "$2")
      shift 2
      ;;
    --remove | --add)
      if (($# < 2)); then usage; fi
      if [[ $1 == --remove ]]; then
        removes+=("$2")
      else
        adds+=("$2")
      fi
      shift 2
      ;;
    *)
      usage
      ;;
    esac
  done
  # Prune/remove first, add last: at most one download per listed patch.
  cmd_prune
  if (("${#removes[@]}" > 0)); then cmd_remove "${removes[@]}"; fi
  if $do_refresh; then
    refresh_all
    echo "Downloaded patches to: $output_dir" >&2
  fi
  if (("${#adds[@]}" > 0)); then
    if [[ -n $add_priority ]]; then
      cmd_add --priority "$add_priority" "${adds[@]}"
    else
      cmd_add "${adds[@]}"
    fi
  fi
  ;;
add)
  shift
  cmd_add "$@"
  ;;
remove)
  shift
  cmd_remove "$@"
  ;;
prune)
  cmd_prune
  ;;
*)
  usage
  ;;
esac
