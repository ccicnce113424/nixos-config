{ pkgs, ... }:
{
  services.fluidsynth = {
    enable = true;
    soundFont = "${pkgs.soundfont-generaluser}/share/soundfonts/GeneralUser-GS.sf2";
    soundService = "pipewire-pulse";
  };
}
