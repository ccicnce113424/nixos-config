{
  pkgs,
  inputs,
  inputs',
  ...
}:
let
  wine = inputs'.nix-gaming.packages.wine-tkg-ntsync;
in
{
  imports = [ inputs.nix-gaming.nixosModules.ntsync ];
  programs.wine.ntsync.enable = true;
  environment.systemPackages =
    [
      wine
      (pkgs.runCommand "wine-alias" { buildInputs = [ wine ]; } ''
        mkdir -p $out/bin
        ln -s ${wine}/bin/wine $out/bin/wine64
      '')
    ]
    ++ (with inputs'.nix-gaming.packages; [
      wineprefix-preparer
      winetricks-git
    ]);
}
