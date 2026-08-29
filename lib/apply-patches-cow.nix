{
  runCommandLocal,
  patchutils,
}:
{
  name ? src.name + "-patched",
  src,
  ...
}@args:
runCommandLocal name
  (
    removeAttrs args [
      "name"
    ]
    // {
      __structuredAttrs = true;
      nativeBuildInputs = [
        patchutils
      ];
      # stdenv would unpack src into the build dir and apply $patches itself;
      # both phases are replaced by the buildCommand below.
      dontUnpack = true;
      dontPatch = true;
    }
  )
  ''
    mkdir -p "$out"

    # Copy-on-write with lazy materialization. Instead of lndir-ing the whole
    # tree (too heavy for large sources such as nixpkgs), link only $src's
    # direct members and make real exactly the files and directories a patch
    # touches. Untouched subtrees stay a single symlink into the store.
    shopt -s dotglob nullglob
    for member in "$src"/*; do
      ln -s "$member" "$out/"
    done

    # materialize_dir <rel>: turn $out/<rel> from a symlink into a real
    # directory holding symlinks to all of $src/<rel>'s direct children.
    # Parents are materialized first, bottom-up; the walk stops at the first
    # ancestor that does not exist in $src, in which case the patch itself
    # creates the remaining path when it is applied.
    materialize_dir() {
      local rel=$1 parent=
      parent=''${rel%/*}
      if [ "$parent" != "$rel" ]; then
        materialize_dir "$parent"
      fi
      [ -L "$out/$rel" ] || return 0
      rm "$out/$rel"
      mkdir -p "$out/$rel"
      for member in "$src/$rel"/*; do
        ln -s "$member" "$out/$rel/"
      done
    }

    # materialize_file <rel>: replace $out/<rel> (a symlink into the store)
    # with a writable copy, materializing parent directories first.
    materialize_file() {
      local rel=$1 parent=
      parent=''${rel%/*}
      if [ "$parent" != "$rel" ]; then
        materialize_dir "$parent"
      fi
      [ -e "$src/$rel" ] || return 0
      if [ -d "$src/$rel" ] && [ ! -L "$src/$rel" ]; then
        materialize_dir "$rel"
        return 0
      fi
      [ -L "$out/$rel" ] || return 0
      # -a preserves symlinks inside $src as they are; --remove-destination
      # unlinks our symlink first instead of writing through it into the store.
      cp -a --remove-destination "$src/$rel" "$out/$rel"
      chmod u+w "$out/$rel"
    }

    # Classify every path any patch touches into two disjoint, deduplicated
    # sets. GNU patch aborts a rename unless the source file is real and
    # writable inside a real directory AND the destination's directory is
    # real, so rename sources must join the a/ set (whole file) and rename
    # destinations the b/ set (their directory). lsdiff only reports one side
    # of a rename (which side varies with the hunk layout, and a pure rename
    # reports none), so the rename headers are prefixed a//b/ and merged with
    # the lsdiff stream, then extracted by the same sed pass.
    lsdiff_out=$(for p in "''${patches[@]}"; do lsdiff "$p"; done)
    ren_from=$(for p in "''${patches[@]}"; do sed -n 's|^rename from |a/|p' "$p"; done)
    ren_to=$(for p in "''${patches[@]}"; do sed -n 's|^rename to |b/|p' "$p"; done)
    # Root-level flake entry points must be real files: flake sources are
    # read through a store-object accessor that re-roots symlink targets
    # inside the tree, so a symlinked flake.nix is unreachable (spliced
    # "path ... does not exist") and a symlinked flake.lock degrades to
    # "no lock file". Entries missing from $src are ignored downstream.
    a_files=$(printf '%s\n%s\na/flake.nix\na/flake.lock\n' "$lsdiff_out" "$ren_from" | sed -n 's|^a/||p' | sort -u)
    b_files=$(printf '%s\n%s\n' "$lsdiff_out" "$ren_to" | sed -n 's|^b/||p' | sort -u)

    # Materialize once, before any patch runs, so later patches work on
    # earlier patches' results exactly like lndir-based builds did.
    while IFS= read -r f; do
      f=''${f%/}
      [ -n "$f" ] && materialize_file "$f"
    done <<< "$a_files"
    while IFS= read -r f; do
      f=''${f%/}
      [ "''${f%/*}" != "$f" ] && materialize_dir "''${f%/*}"
    done <<< "$b_files"

    for p in "''${patches[@]}"; do
      # Everything is in place; apply the patches in order.
      echo "applying patch $p"
      patch -p1 -d "$out" < "$p"
    done
  ''
