{
  pkgs,
  inputs,
  inputs',
  ...
}:
{
  imports = [ inputs.nix-gaming.nixosModules.wine ];
  programs.wine = {
    enable = true;
    package = inputs'.nix-gaming.packages.wine-tkg;
    binfmt = true;
    ntsync = true;
  };
  environment.systemPackages = with inputs'.nix-gaming.packages; [
    # following packages are from nix-gaming
    (wineprefix-preparer.override {
      withDdraw = true;
      dxvk-w64 = pkgs.dxvk-gplall-bin-w64;
      dxvk-w32 = pkgs.dxvk-gplall-bin-w32;
    })
    winetricks-git
  ];
}
