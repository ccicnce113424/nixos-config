{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qq
    wechat-uos
    wemeet
    telegram-desktop
    tor-browser
    qbittorrent-enhanced
    motrix
    nheko

    nur.repos.xddxdd.peerbanhelper
  ];

  imports = [ ./firefox ];
}
