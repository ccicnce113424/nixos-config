{
  lib,
  ...
}:
{
  findPkgs =
    names: pkgsList:
    let
      nameSet = lib.genAttrs names (_: null);
      getPackageName =
        p:
        p.pname or (builtins.parseDrvName (
          p.name or (p |> builtins.unsafeDiscardStringContext |> baseNameOf |> (builtins.substring 33 (-1)))
        )).name;
      filtered = builtins.filter (p: builtins.hasAttr (getPackageName p) nameSet) pkgsList;
      groups = builtins.groupBy (p: p.pname) filtered;
    in
    builtins.mapAttrs (_name: pkgs: builtins.head pkgs) groups;
  # builtins.mapAttrs (name: _: builtins.head groups.${name} or [ null ]) nameSet;

}
