{ pkgs, ... }:
{
  home.packages = [
    pkgs.qq
    pkgs.nur.repos.novel2430.wechat-universal-bwrap
    pkgs.nur.repos.novel2430.wemeet-bin-bwrap-wayland-screenshare
    pkgs.telegram-desktop
    pkgs.tor-browser
    pkgs.qbittorrent-enhanced
    pkgs.motrix
  ];

  imports = [ ./firefox ];
}
