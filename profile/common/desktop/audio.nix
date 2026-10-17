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
            "default.clock.min-quantum" = 128;
            "default.clock.max-quantum" = 512;
            "default.clock.quantum" = 256;
          };
        };
      };

      wireplumber.extraConfig = {
        "51-ja11-volume-fix" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "device.vendor.id" = "0x2972";
                }
                {
                  "device.vendor.id" = "0x31b2";
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
        "52-lhdc-quality" = {
          "monitor.bluez.rules" = [
            {
              matches = [ { "device.description" = "MOONDROP Pudding"; } ];
              actions = {
                update-props = {
                  "bluez5.a2dp.lhdc.quality" = "500k";
                };
              };
            }
          ];
        };
      };
      alsa.support32Bit = lib.mkIf config.enable32Bit true;
    };

    services.pipewire-bluez5-lhdc.enable = true;

    environment.systemPackages = with pkgs; [ alsa-utils ];
  };
}
