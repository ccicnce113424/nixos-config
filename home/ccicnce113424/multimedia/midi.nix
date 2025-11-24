{
  pkgs,
  config,
  lib,
  ...
}:
{
  services.fluidsynth = {
    enable = true;
    soundFont = "${pkgs.soundfont-arachno}/share/soundfonts/arachno.sf2";
    soundService = "pipewire-pulse";
  };
  home.packages = with pkgs; [
    fluidsynth
    rosegarden
  ];
  home.file.".local/share/soundfonts/default.sf2".source = config.services.fluidsynth.soundFont;
  # Disable the automatic start of fluidsynth with systemd
  systemd.user.services.fluidsynth.Install.WantedBy = lib.mkForce [ ];
}
