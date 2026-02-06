{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    qq
    wechat-uos
    wemeet
    ayugram-desktop
    tor-browser
    qbittorrent-enhanced
    imfile
    fluffychat
    cherry-studio

    nur.repos.xddxdd.peerbanhelper
  ];

  imports = [
    ./firefox.nix
  ];
}
