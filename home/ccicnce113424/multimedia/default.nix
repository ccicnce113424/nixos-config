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
    danmakufactory
    splayer-git

    oneanime
    kazumi
    venera
    pixes-git
    piliplus
  ];

  services.easyeffects.enable = true;
  midi.enable = true;

  imports = [
    ./midi.nix
    ./mpd.nix
    ./mpv
  ];
}
