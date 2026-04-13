{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.runtime.profile == "desktop") {
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;

      wireplumber.enable = true;

      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;

      extraConfig.pipewire = {
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

      wireplumber.extraConfig = {
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
    }
    // lib.optionalAttrs config.enable32Bit {
      alsa.support32Bit = true;
    };

    environment.systemPackages = with pkgs; [ alsa-utils ];
  };
}
