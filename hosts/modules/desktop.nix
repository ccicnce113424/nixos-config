{ pkgs, ... }:
{
  boot.kernelModules = [ "pcspkr" ];
  services.pipewire.extraConfig.pipewire = {
    "10-no-resample-and-low-quantum" = {
      "context.properties" = {
        "default.clock.allowed-rates" = [
          8000
          16000
          32000
          44100
          48000
          88200
          96000
          176400
          192000
          352800
          384000
        ];
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 256;
        "default.clock.quantum" = 128;
      };
    };
  };

  services.pipewire.wireplumber.extraConfig = {
    "ja11-volume-fix" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "device.name" = "~alsa_card.usb-FIIO_JadeAudio_JA11*";
            }
          ];
          actions = {
            update-props = {
              "api.alsa.ignore-dB" = true;
            };
          };
        }
      ];
    };
  };

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

  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  services.ipp-usb.enable = true;

  i18n.supportedLocales = [
    "zh_CN.UTF-8/UTF-8"
    "en_US.UTF-8/UTF-8"
    "ja_JP.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
  ];
}
