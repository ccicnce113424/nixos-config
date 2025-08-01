{
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.nix-gaming.nixosModules.wine ];
  programs.wine = {
    enable = true;
    package = pkgs.wine-tkg-ntsync;
    binfmt = true;
    ntsync = true;
  };
  environment.systemPackages = with pkgs; [
    # following packages are from nix-gaming
    wineprefix-preparer
    winetricks-git
  ];
}
