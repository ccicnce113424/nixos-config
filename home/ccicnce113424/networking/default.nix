{
  pkgs,
  lib,
  host,
  ...
}:
{
  home.packages =
    (with pkgs; [
      nur.repos.lonerOrz.qq
      wechat
      wemeet
      ayugram-desktop
      tor-browser
      qbittorrent-enhanced
      motrix
      nheko
      cherry-studio

      nur.repos.xddxdd.peerbanhelper
    ])
    # https://github.com/NixOS/nixpkgs/issues/424868
    ++ lib.optional host.hostCfg.gpu.nvidia or false (
      lib.hiPrio (
        pkgs.writeShellScriptBin "AyuGram" ''
          WEBKIT_DISABLE_DMABUF_RENDERER=1 exec ${pkgs.ayugram-desktop}/bin/AyuGram "$@"
        ''
      )
    );

  imports = [
    ./firefox.nix
  ];
}
