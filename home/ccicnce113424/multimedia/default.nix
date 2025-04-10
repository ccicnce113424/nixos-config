{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    waylyrics
    mediainfo
    mediainfo-gui
    tenacity
    ffmpeg-full
    gimp-with-plugins
    nur.repos.xddxdd.ncmdump-rs

    # bilibili
  ];

  imports = [
    ./mpd
    ./mpv
  ];
}
