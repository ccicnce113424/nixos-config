{ pkgs, ... }:
{
  services.fluidsynth = {
    enable = true;
    soundFont = "${pkgs.soundfont-arachno}/share/soundfonts/arachno.sf2";
    soundService = "pipewire-pulse";
  };
  home.packages = with pkgs; [ fluidsynth ];
}
