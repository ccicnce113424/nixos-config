{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.midi;
in
{
  options.midi.enable = lib.mkEnableOption "";
  config = lib.mkIf cfg.enable {
    lservices.fluidsynth = {
      enable = true;
      extraOptions = [ "--sample-rate 48000" ];
      soundFont = "${pkgs.soundfont-arachno}/share/soundfonts/arachno.sf2";
      soundService = "pipewire-pulse";
    };
    home.packages = with pkgs; [
      fluidsynth
      rosegarden
    ];
    home.file.".local/share/soundfonts/default.sf2".source = config.services.fluidsynth.soundFont;
  };
}
