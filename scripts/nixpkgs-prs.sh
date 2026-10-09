#!/usr/bin/env bash
set -euo pipefail

# Manifest of nixpkgs PRs whose patches are applied to nixpkgs.
# Run from the repository root via `just pr` / `nix run .#nixpkgs-prs`
# (direct execution needs curl, jq and moreutils on PATH).
manifest=nixpkgs-prs.json
output_dir=patches/nixpkgs-pr

usage() {
  {
    echo "Usage: nixpkgs-prs [show | update | add | remove | prune] [ARGS...]"
    echo
    echo "  nixpkgs-prs               same as show (default)"
    echo "  nixpkgs-prs show          list PRs: patch/PR state, branch reached, links"
    echo "  nixpkgs-prs update        prune landed PRs, then apply --remove/--add"
    echo "                            options: --refresh (re-download every patch), --remove REF, --add REF (repeatable)"
    echo "  nixpkgs-prs add REF...    add PRs to $manifest, then download their patches"
    echo "  nixpkgs-prs remove REF... remove PRs from $manifest, then delete their patches"
    echo "  nixpkgs-prs prune         drop PRs already in the nixpkgs pinned in flake.lock"
    echo
    echo "REF is a PR number or https://github.com/NixOS/nixpkgs/pull/<number>"
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
  local file="$output_dir/$n.patch"
  if [[ ! -f $file ]]; then
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

download_pr() {
  local url=$1
  local n="${url##*/}"
  local rev="${2:-}" # head rev; callers that already fetched the PR pass it in
  if [[ -z $rev ]]; then
    rev=$(api_get "pulls/$n" | jq -r '.head.sha // empty | strings' || true)
  fi
  mkdir -p "$output_dir"
  echo "Downloading PR #$n..." >&2
  curl -fL --retry 5 --retry-all-errors --speed-limit 1024 --speed-time 15 \
    --output "$output_dir/$n.patch" "$url.patch"
  # Record the head rev this patch was fetched at, so `show` can compare without
  # downloading. Captured before the patch: a race then yields a harmless false
  # "stale" instead of a false "ok".
  if [[ -n $rev ]]; then
    jq --arg url "$url" --arg rev "$rev" \
      'map(if .url == $url then .rev = $rev else . end)' "$manifest" | sponge "$manifest"
  fi
}

refresh_all() {
  shopt -s nullglob
  local old_patches=("$output_dir"/*.patch "$output_dir"/*.diff)
  if (("${#old_patches[@]}")); then
    echo "Cleaning existing patch files in: $output_dir" >&2
    rm -f -- "${old_patches[@]}"
  fi
  local urls=()
  mapfile -t urls < <(jq -r '.[].url' "$manifest")
  local url
  for url in "${urls[@]}"; do
    download_pr "$url"
  done
}

cmd_add() {
  if (($# == 0)); then usage; fi
  local ref url n rev
  for ref in "$@"; do
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
    download_pr "$url" "$rev"
  done
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
    rm -f -- "$output_dir/$n.patch" "$output_dir/$n.diff"
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
    rm -f -- "$output_dir/${url##*/}.patch" "$output_dir/${url##*/}.diff"
  done
  echo "Dropped ${#drop[@]} PR(s) already in the pinned nixpkgs" >&2
}

cmd_show() {
  if (($(jq 'length' "$manifest") == 0)); then
    echo "No PRs listed in $manifest"
    return 0
  fi
  local n url title info state head_sha merge_sha patch_state tracker reached
  local rest r_unstable r_small r_master
  while IFS= read -r url; do
    n="${url##*/}"
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
    printf '  %-9s %s\n' 'pr:' "${state:-?}"
    if [[ -n $reached ]]; then
      printf '  %-9s %s\n' 'in:' "$reached"
    fi
    printf '  %-9s %s\n' 'link:' "$url"
    if [[ -n $tracker ]]; then
      printf '  %-9s %s\n' 'tracker:' "$tracker"
    fi
    echo
  done < <(jq -r '.[].url' "$manifest")
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
  while (($# > 0)); do
    case "$1" in
    --refresh)
      do_refresh=true
      shift
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
  if (("${#adds[@]}" > 0)); then cmd_add "${adds[@]}"; fi
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
