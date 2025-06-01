{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    waylyrics
    mediainfo
    mediainfo-gui
    tenacity
  ];

  services.easyeffects.enable = true;

  imports = [
    ./midi.nix
    ./mpd.nix
    ./mpv
  ];
}
