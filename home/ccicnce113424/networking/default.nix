{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qq
    wechat
    wemeet
    telegram-desktop
    tor-browser
    qbittorrent-enhanced
    motrix
    nheko
    cherry-studio

    nur.repos.xddxdd.peerbanhelper
  ];

  imports = [
    ./firefox.nix
  ];
}
