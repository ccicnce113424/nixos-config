{ pkgs, ... }:
{
  boot.kernelModules = [ "pcspkr" ];

  services.printing = {
    enable = true;
    openFirewall = true;
    cups-pdf = {
      enable = true;
      instances.PDF.settings.Out = "\${HOME}/cups-pdf";
    };
  };

  hardware.sane = {
    enable = true;
    openFirewall = true;
    extraBackends = with pkgs; [ sane-airscan ];
  };

  hardware.uinput.enable = true;

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  services.ipp-usb.enable = true;

}
