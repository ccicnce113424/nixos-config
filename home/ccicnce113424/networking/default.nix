{ pkgs, ... }:
{
  home.packages = [
    pkgs.qq
    pkgs.wechat-uos
    pkgs.nur.repos.novel2430.wemeet-bin-bwrap-wayland-screenshare
    pkgs.telegram-desktop
    pkgs.tor-browser
    pkgs.qbittorrent-enhanced
    pkgs.motrix
  ];

  imports = [ ./firefox ];

  programs.chromium.enable = true;
}
