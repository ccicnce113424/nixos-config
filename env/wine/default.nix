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
    [ wine ]
    ++ (with pkgs; [
      # following packages are from nix-gaming
      wineprefix-preparer
      winetricks-git
    ]);

  environment.sessionVariables = {
    WINE_BIN = "/run/current-system/sw/bin/wine";
  };
}
