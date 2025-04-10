{ pkgs, ... }:
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

  home.packages = [ pkgs.cantata ];
}
