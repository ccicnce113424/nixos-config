{ ... }:
{
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
      audio_output {
        type "alsa"
        name "ALSA Output"
        mixer_control "Master"
        dop "yes"
      }
      audio_output {
        type "jack"
        name "Jack Output"
      }
    '';
  };
  services.mpd-mpris.enable = true;

  services.flatpak.packages = [ "dog.unix.cantata.Cantata" ];
}
