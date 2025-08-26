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
  ];

  services.easyeffects.enable = true;
  midi.enable = true;

  imports = [
    ./midi.nix
    ./mpd.nix
    ./mpv
  ];
}
