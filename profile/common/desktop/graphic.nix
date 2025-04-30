{
  pkgs,
  config,
  lib,
  ...
}:
{
  hardware.graphics = {
    enable = true;
  } // lib.optionalAttrs config.enable32Bit { enable32Bit = true; };

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  programs.xwayland.enable = true;

  services.colord.enable = true;

  # services.kmscon = {
  #   enable = true;
  #   hwRender = true;
  #   # extraConfig = "font-size=18";
  # };

  environment.systemPackages = [
    pkgs.nvtopPackages.full
    pkgs.weston
    pkgs.mesa-demos
    pkgs.vulkan-tools
  ];

  programs.nix-ld.libraries = [
    pkgs.xorg.libX11
    pkgs.xorg.libXext
    pkgs.xorg.libXi
    pkgs.xorg.libXrender
    pkgs.xorg.libXtst
    pkgs.fontconfig
  ];
}
