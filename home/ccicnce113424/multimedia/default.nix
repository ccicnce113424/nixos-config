{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    waylyrics
    mediainfo
    mediainfo-gui
    tenacity
    danmakufactory
  ];

  services.easyeffects.enable = true;

  imports = [
    ./midi.nix
    ./mpd.nix
    ./mpv
  ];
}
