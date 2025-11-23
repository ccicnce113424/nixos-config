{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    waylyrics
    mediainfo
    mediainfo-gui
    tenacity
    ruffle
    danmakufactory
    splayer-git

    oneanime
    kazumi
    venera
    pixes-git
    piliplus
  ];

  # https://github.com/nix-community/home-manager/issues/8185
  # services.easyeffects.enable = true;
  midi.enable = false;

  imports = [
    ./midi.nix
    ./mpd.nix
    ./mpv
  ];
}
