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

  services.easyeffects.enable = true;

  imports = [
    ./fluidsynth.nix
    ./mpd.nix
    ./mpv
  ];
}
