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
          nameSet = lib.genAttrs names (_: null);
          getPackageName =
            p:
            p.pname or (builtins.parseDrvName (
              p.name or (builtins.substring 33 (-1) (baseNameOf (builtins.unsafeDiscardStringContext p)))
            )).name;
          filtered = builtins.filter (p: builtins.hasAttr (getPackageName p) nameSet) pkgsList;
          groups = builtins.groupBy getPackageName filtered;
        in
        assert builtins.attrNames nameSet == builtins.attrNames groups;
        builtins.mapAttrs (_name: pkgs: builtins.head pkgs) groups;
    };
    pathToPatchList = lib.mkOption {
      default =
        path:
        if builtins.pathExists path then
          lib.fileset.toList (
            lib.fileset.fileFilter (
              file:
              lib.any (ext: lib.hasSuffix ext file.name) [
                ".patch"
                ".diff"
              ]
            ) path
          )
        else
          [ ];
    };
  };
}
