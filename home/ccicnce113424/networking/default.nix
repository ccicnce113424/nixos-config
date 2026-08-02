{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    enimul
    # wemeet
    telegram-desktop
    tor-browser
    qbittorrent-enhanced
    motrix-next-beta
    cherry-studio

    nur.repos.xddxdd.peerbanhelper
    qq

    wechat-uos
  ];
  programs.element-desktop.enable = true;

  imports = [
    ./firefox.nix
  ];
}
