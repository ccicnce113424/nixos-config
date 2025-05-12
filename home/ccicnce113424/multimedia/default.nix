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

    (pkgs.av1an.override {
      withSvtav1 = true;
      withRav1e = true;
      withVmaf = true;
    })
  ];

  services.easyeffects.enable = true;

  imports = [
    ./midi.nix
    ./mpd.nix
    ./mpv
  ];
}
