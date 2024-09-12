{ config, pkgs, ... }:

{
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;

    wireplumber.enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire = {
      "10-no-resample-and-low-quantum" = {
        "context.properties" = {
          "default.clock.allowed-rates" = [ 44100 48000 96000 192000 ];
          "default.clock.min-quantum" = 16;
          "default.clock.max-quantum" = 128;
          "default.clock.quantum" = 64;
        };
      }
    };
  }
}