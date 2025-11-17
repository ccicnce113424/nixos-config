{
  lib,
  ...
}:
{
  findPkgs =
    names: pkgsList:
    let
      nameSet = lib.genAttrs names (_: null);
      filtered = builtins.filter (p: builtins.hasAttr p.pname nameSet) pkgsList;
      groups = builtins.groupBy (p: p.pname) filtered;
    in
    builtins.mapAttrs (name: pkgs: builtins.head pkgs) groups;
  # builtins.mapAttrs (name: _: builtins.head groups.${name} or [ null ]) nameSet;

}
