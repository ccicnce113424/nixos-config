{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    waylyrics
    gimp
  ];

  imports = [ ./mpv.nix ];
}
