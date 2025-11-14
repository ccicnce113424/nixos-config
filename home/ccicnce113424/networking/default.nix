{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # nur.repos.lonerOrz.qq
    qq
    wechat
    wemeet
    ayugram-desktop
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
