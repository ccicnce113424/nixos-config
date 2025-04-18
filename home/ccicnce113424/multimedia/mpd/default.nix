{ ... }:
{
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type "alsa"
        name "ALSA Output"
        mixer_control "Master"
        dop "yes"
      }
    '';
  };
  services.mpd-mpris.enable = true;

  services.flatpak.packages = [ "dog.unix.cantata.Cantata" ];
}
