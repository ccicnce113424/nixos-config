{
  runCommandLocal,
  lndir,
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
        lndir
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
    lndir -silent -ignorelinks "$src" "$out"

    # Union of all pre-existing files (the a/ prefix in lsdiff output) touched
    # by any patch, deduplicated. Materializing them once, before any patch
    # runs, keeps later patches working on earlier patches' results.
    for p in $patches; do
      lsdiff "$p" | sed -n 's|^a/||p'
    done | sort -u | while IFS= read -r f; do
      # Replace lndir's symlink with a verbatim copy (-a preserves symlinks
      # as-is) and drop the store's read-only mode so patch can write to it.
      if [ -L "$out/$f" ]; then
        cp -a --remove-destination "$src/$f" "$out/$f"
        chmod u+w "$out/$f"
      fi
    done

    for p in $patches; do
      # Everything is in place; apply the patches in order.
      echo "applying patch $p"
      patch -p1 -d "$out" < "$p"
    done
  ''
