{ config, pkgs, ... }:
{
  services.printing = {
    enable = true;
    cups-pdf = {
      enable = true;
      instances.PDF.settings.Out = "\${HOME}/cups-pdf";
    };
  };
}