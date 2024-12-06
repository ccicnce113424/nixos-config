{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    netease-cloud-music-gtk
    waylyrics
    gimp
  ];
}
