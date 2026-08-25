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

    # nur.repos.xddxdd.peerbanhelper
    # nur.repos.lonerOrz.qq

    (nur.repos.mio.qq_bwrap.override {
      bindDesktop = true;
      bindDocuments = true;
    })
    (nur.repos.mio.wechat_bwrap.override {
      bindDesktop = true;
      bindDocuments = true;
      followSystemAppearance = true;
    })
  ];
  programs.element-desktop.enable = true;

  imports = [
    ./firefox.nix
  ];
}
