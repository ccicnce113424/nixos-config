{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.nix-gaming.nixosModules.wine ];
  programs.wine = {
    enable = true;
    package = pkgs.wine-tkg;
    binfmt = true;
    ntsync = true;
  };
  environment.systemPackages = with pkgs; [
    # following packages are from nix-gaming
    (wineprefix-preparer.override { withDdraw = true; })
    winetricks-git
  ];
}
