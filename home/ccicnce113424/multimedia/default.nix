{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    nur.repos.rewine.electron-netease-cloud-music
    waylyrics
    gimp
    mediainfo
    mediainfo-gui
    bilibili
    tenacity
    ffmpeg-full
  ];

  imports = [ ./mpv ];
}
