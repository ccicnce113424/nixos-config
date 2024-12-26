{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    nur.repos.rewine.electron-netease-cloud-music
    waylyrics
    gimp
  ];

  imports = [ ./mpv.nix ];
}
