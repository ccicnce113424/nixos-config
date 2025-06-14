{
  pkgs,
  inputs,
  ...
}:
let
  # from nix-gaming
  wine = pkgs.wine-tkg-ntsync;
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
    ++ (with pkgs; [
      # following packages are from nix-gaming
      wineprefix-preparer
      winetricks-git
    ]);
}
