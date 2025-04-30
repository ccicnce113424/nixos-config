{ pkgs, config, ... }:
{
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;

    wireplumber.enable = true;

    alsa.enable = true;
    alsa.support32Bit = config.enable32Bit;
    pulse.enable = true;
    jack.enable = true;
  };

  environment.systemPackages = [
    pkgs.alsa-utils
    pkgs.easyeffects
  ];
}
