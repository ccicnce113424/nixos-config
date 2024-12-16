{ pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.enable = true;
  programs.xwayland.enable = true;

  services.colord.enable = true;

  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = "font-size=18";
  };

  environment.systemPackages = [ pkgs.nvtopPackages.full ];
}
