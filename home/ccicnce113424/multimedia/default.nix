{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    waylyrics
    mediainfo
    mediainfo-gui
    tenacity
    ruffle
    danmakufactory-git
    splayer-git
    algermusicplayer

    oneanime
    kazumi
    venera
    pixes-git
    animeko
  ];

  services.easyeffects.enable = true;

  imports = [
    ./midi.nix
    ./mpd.nix
    ./mpv
  ];
}
