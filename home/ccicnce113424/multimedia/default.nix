{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    nur.repos.xddxdd.netease-cloud-music
    nur.repos.xddxdd.ncmdump-rs
    waylyrics
    gimp
    mediainfo
    mediainfo-gui
    bilibili
  ];

  imports = [ ./mpv ];
}
