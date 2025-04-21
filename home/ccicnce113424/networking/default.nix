{ pkgs, ... }:
{
  home.packages = [
    pkgs.qq
    pkgs.wechat-uos
    pkgs.wemeet
    pkgs.telegram-desktop
    pkgs.tor-browser
    pkgs.qbittorrent-enhanced
    pkgs.motrix
  ];

  imports = [ ./firefox ];
}
