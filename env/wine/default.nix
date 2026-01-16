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
    rpc-bridge

    # following packages are from nix-gaming
    (wineprefix-preparer.override {
      withDdraw = true;
      dxvk-w64 = pkgs.dxvk-gplall-bin-w64;
      dxvk-w32 = pkgs.dxvk-gplall-bin-w32;
    })
    winetricks-git
  ];
}
