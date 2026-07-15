{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.runtime.profile == "desktop") {
    hardware.graphics = {
      enable = true;
      enable32Bit = lib.mkIf config.enable32Bit true;
    };

    programs.xwayland.enable = true;

    services.colord.enable = true;

    services.kmscon = {
      enable = true;
      config = {
        hwaccel = true;
        font-size = 24;
        bell = true;
      };
    };

    environment.systemPackages = with pkgs; [
      weston
      mesa-demos
      vulkan-tools
    ];

    programs.nix-ld.libraries = with pkgs; [
      libX11
      libXext
      libXi
      libXrender
      libXtst
      fontconfig
      icu
    ];
  };
}
