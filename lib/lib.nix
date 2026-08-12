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
          matching = builtins.filter (p: nameSet ? ${lib.getName p}) pkgsList;
          groups = builtins.groupBy lib.getName matching;
          notFound = lib.subtractLists (builtins.attrNames groups) names;
        in
        assert lib.assertMsg (notFound == [ ]) "Packages not found: ${lib.concatStringsSep ", " notFound}";
        builtins.mapAttrs (_name: builtins.head) groups;
    };
    pathToPatchFileset = lib.mkOption {
      default = lib.fileset.fileFilter (
        { hasExt, ... }:
        lib.any hasExt [
          "patch"
          "diff"
        ]
      );
    };
  };
}
