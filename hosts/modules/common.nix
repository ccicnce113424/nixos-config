{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.hostCfg.locale = lib.mkOption {
    type = lib.types.str;
    default = "CN";
  };
  config = lib.mkMerge [
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
        cups-pdf = {
          enable = true;
          instances.PDF.settings.Out = "\${HOME}/cups-pdf";
        };
      };

      services.udev.packages = with pkgs; [
        game-devices-udev-rules
        android-udev-rules
      ];

      systemd.services."usb-lp-acl@" = {
        description = "Description=Set ACL for lp group on USB device %I";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = ''${pkgs.acl}/bin/setfacl -m g:lp:rw %I'';
        };
      };

      i18n.supportedLocales = [
        "zh_CN.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
        "ja_JP.UTF-8/UTF-8"
        "C.UTF-8/UTF-8"
      ];
    }
    (lib.mkIf ("CN" == config.hostCfg.locale) {
      time = {
        timeZone = "Asia/Shanghai";
        # hardwareClockInLocalTime = true;
      };

      i18n.defaultLocale = "zh_CN.UTF-8";

      nix.settings.substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];
    })
  ];
}
