{
  lib,
  ...
}:
{
  options.lib' = {
    findPkgs = lib.mkOption {
      default =
        names: pkgsList:
        let
          # nameSet = lib.genAttrs names (_: null);
          # matching = builtins.filter (p: builtins.hasAttr (lib.getName p) nameSet) pkgsList;
          matching = builtins.filter (p: builtins.elem (lib.getName p) names) pkgsList;
          groups = builtins.groupBy lib.getName matching;
        in
        # assert builtins.attrNames nameSet == builtins.attrNames groups;
        assert builtins.sort builtins.lessThan names == builtins.attrNames groups;
        builtins.mapAttrs (_name: builtins.head) groups;
    };
    pathToPatchFileset = lib.mkOption {
      default =
        path:
        lib.fileset.fromSource (
          lib.sources.sourceFilesBySuffices path [
            ".patch"
            ".diff"
          ]
        );
    };
  };
}
