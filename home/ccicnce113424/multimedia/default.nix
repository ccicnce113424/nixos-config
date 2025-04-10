{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    nur.repos.rewine.electron-netease-cloud-music
    waylyrics
    mediainfo
    mediainfo-gui
    tenacity
    ffmpeg-full
    gimp-with-plugins
    nur.repos.xddxdd.ncmdump-rs

    # bilibili
  ];

  imports = [ ./mpv ];
}
