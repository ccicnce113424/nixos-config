{
  pkgs,
  config,
  lib,
  ...
}:
{
  hardware.graphics = {
    enable = true;
  }
  // lib.optionalAttrs config.enable32Bit { enable32Bit = true; };

  programs.xwayland.enable = true;

  services.colord.enable = true;

  services.kmscon = {
    enable = true;
    hwRender = true;
    term = "xterm-256color";
    extraConfig = "font-size=18";
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
  ];
}
