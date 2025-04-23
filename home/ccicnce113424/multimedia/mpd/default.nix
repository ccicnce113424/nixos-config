{ ... }:
{
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type          "pipewire"
        name          "PipeWire Output"
        enabled       "yes"
      }
      audio_output {
        type          "alsa"
        name          "ALSA JA11 DoP Output"
        device        "hw:CARD=JA11"
        mixer_device  "pipewire"
        mixer_control "Master"
        dop           "yes"
        enabled       "no"
      }
    '';
  };
  services.mpd-mpris.enable = true;

  services.flatpak.packages = [ "dog.unix.cantata.Cantata" ];
}
