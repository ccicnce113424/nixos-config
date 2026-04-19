{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    lumine
    wemeet
    ayugram-desktop
    tor-browser
    qbittorrent-enhanced
    motrix-next-beta
    fluffychat
    cherry-studio

    nur.repos.xddxdd.peerbanhelper
    nur.repos.lonerOrz.qq

    (pkgs.symlinkJoin {
      name = "wechat-fcitx";
      paths = [ pkgs.wechat ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/wechat \
          --set-default QT_QPA_PLATFORM xcb \
          --set-default QT_AUTO_SCREEN_SCALE_FACTOR 1 \
          --set-default QT_IM_MODULE fcitx \
          --set-default GTK_IM_MODULE fcitx
      '';
    })
  ];

  imports = [
    ./firefox.nix
  ];
}
