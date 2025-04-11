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
  services.mpd-mpris.enable = true;

  home.packages = [ pkgs.nur.repos.bandithedoge.cantata ]; # Remember to disable mpris in cantata
}
