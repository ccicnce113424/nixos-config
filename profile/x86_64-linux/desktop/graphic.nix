{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.xwayland.enable = true;

  services.colord.enable = true;
  
  services.kmscon.enable = true;
  services.kmscon.hwRender = true;
}