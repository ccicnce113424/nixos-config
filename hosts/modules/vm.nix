{ lib, config, ... }:
let
  vmCfg = {
    vbox = {
      virtualisation.virtualbox.guest = {
        enable = true;
        dragAndDrop = true;
        clipboard = true;
      };
    };
    vmware = {
      services.xserver.videoDrivers = [ "vmware" ];
      virtualisation.vmware.guest.enable = true;
    };
  };
  cfg = config.hostCfg.vm;
in
{
  options.hostCfg.vm = {
    enable = lib.mkEnableOption "";
  }
  // builtins.mapAttrs (n: _: lib.mkEnableOption n) vmCfg;
  config = lib.mkIf cfg.enable (
    lib.mkMerge (
      [
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
      ]
      ++ lib.mapAttrsToList (type: c: (lib.mkIf cfg.${type} c)) vmCfg
    )
  );
}
