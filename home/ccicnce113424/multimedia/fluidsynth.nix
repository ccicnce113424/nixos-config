{ pkgs, ... }:
{
  services.fluidsynth = {
    enable = true;
    soundFont = "${pkgs.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
    soundService = "pipewire-pulse";
  };
}
