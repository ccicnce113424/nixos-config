{ lib, config, ... }:
let
  cfg = config.hostCfg.vm;
in
{
  options.hostCfg.vm = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
    type = lib.mkOption {
      type = lib.types.enum [
        "vbox"
        "vmware"
        ""
      ];
      default = "";
    };
  };
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.pipewire.wireplumber.extraConfig = {
          "50-alsa-config" = {
            "monitor.alsa.rules" = [
              {
                matches = [
                  {
                    "node.name" = "~alsa_output.*";
                  }
                ];
                actions = {
                  update-props = {
                    "api.alsa.period-size" = 1024;
                    "api.alsa.headroom" = 8192;
                  };
                };
              }
            ];
          };
        };
      }
      (lib.mkIf ("vbox" == cfg.type) {
        virtualisation.virtualbox.guest = {
          enable = true;
          dragAndDrop = true;
          clipboard = true;
        };
      })
      (lib.mkIf ("vmware" == cfg.type) {
        services.xserver.videoDrivers = [ "vmware" ];
        virtualisation.vmware.guest.enable = true;
      })
    ]
  );
}
