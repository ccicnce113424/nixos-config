{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.nix-gaming.nixosModules.wine ];

  config = lib.mkIf (builtins.elem "wine" config.runtime.features) {
    programs.wine = {
      enable = true;
      package = pkgs.wine-tkg;
      binfmt = true;
      ntsync = true;
    };
    environment.systemPackages = with pkgs; [
      # following packages are from nix-gaming
      rpc-bridge
      (wineprefix-preparer.override {
        withDdraw = true;
        dxvk-w64 = pkgs.dxvk-gplasync-lowlatency-w64;
        dxvk-w32 = pkgs.dxvk-gplasync-lowlatency-w32;
      })
      winetricks-git
    ];
    environment.sessionVariables.WINEDLLPATH = lib.makeSearchPath "lib/wine" [ pkgs.pwasio ];
  };
}
