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
    splayer-next-dev
    open-orpheus-dev

    oneanime
    kazumi
    pixes-git
    piliplus
    loveiwara
    kikoflu
  ];

  # https://github.com/nix-community/home-manager/issues/8185
  services.easyeffects.enable = true;

  imports = [
    ./midi.nix
    ./mpd.nix
    ./mpv
  ];
}
