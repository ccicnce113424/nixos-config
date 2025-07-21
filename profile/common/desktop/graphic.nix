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

  services.xserver.enable = true;
  services.xserver.displayManager.startx.enable = true;
  programs.xwayland.enable = true;

  services.colord.enable = true;

  # services.kmscon = {
  #   enable = true;
  #   hwRender = true;
  #   # extraConfig = "font-size=18";
  # };

  environment.systemPackages = with pkgs; [
    nvtopPackages.full
    weston
    mesa-demos
    vulkan-tools
  ];

  programs.nix-ld.libraries = with pkgs; [
    xorg.libX11
    xorg.libXext
    xorg.libXi
    xorg.libXrender
    xorg.libXtst
    fontconfig
  ];
}
