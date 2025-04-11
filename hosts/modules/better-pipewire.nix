{ ... }:
{
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
        "default.clock.min-quantum" = 16;
        "default.clock.max-quantum" = 256;
        "default.clock.quantum" = 64;
      };
    };
  };

  services.pipewire.wireplumber.extraConfig = {
    "ja11-volume-fix" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "device.name" = "~alsa_output.usb-FIIO_JadeAudio_JA11*";
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
}
