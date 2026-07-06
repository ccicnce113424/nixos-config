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
        withD7vk = true;
        dxvk-w64 = pkgs.dxvk-w64.override { withAsync = false; };
        dxvk-w32 = pkgs.dxvk-w32.override { withAsync = false; };
      })
      winetricks-git
    ];
    environment.sessionVariables.WINEDLLPATH = lib.makeSearchPath "lib/wine" [ pkgs.pwasio ];
  };
}
