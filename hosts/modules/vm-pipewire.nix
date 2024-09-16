{ config, ... }:

{
  imports = [./better-pipewire.nix];
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