{ pkgs, config, ... }:
{
  hardware.graphics = {
    enable = true;
    enable32Bit = config.enable32Bit;
  };

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
