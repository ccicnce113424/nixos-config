{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    waylyrics
    mediainfo
    mediainfo-gui
    tenacity
    danmakufactory-git
    splayer-git

    oneanime
    kazumi
    venera
    # animeko
  ];

  services.easyeffects.enable = true;

  imports = [
    ./midi.nix
    ./mpd.nix
    ./mpv
  ];
}
