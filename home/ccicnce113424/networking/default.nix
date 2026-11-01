{
  pkgs,
  ...
}:
{
  home.packages =
    builtins.attrValues {
      inherit (pkgs)
        enimul
        telegram-desktop
        qbittorrent-enhanced
        rayburst-beta
        qq
        wechat
        ;
    }
    ++ [ pkgs.nur.repos.xddxdd.peerbanhelper ];
  programs.element-desktop.enable = true;

  imports = [
    ./firefox.nix
  ];
}
