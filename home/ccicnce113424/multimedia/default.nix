{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    vlc
    netease-cloud-music-gtk
    waylyrics
    gimp
  ];
}
