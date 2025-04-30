{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.pulseaudio.enable = false;
  services.pipewire =
    {
      enable = true;

      wireplumber.enable = true;

      alsa.enable = true;
      pulse.enable = true;
      jack.enable = true;
    }
    // lib.optionalAttrs config.enable32Bit {
      alsa.support32Bit = true;
    };

  environment.systemPackages = [ pkgs.alsa-utils ];
}
