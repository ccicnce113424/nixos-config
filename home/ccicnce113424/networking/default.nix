{
  pkgs,
  lib,
  host,
  ...
}:
{
  home.packages =
    let
      nvFixWebkitGtk = map (
        pkg:
        let
          exe = lib.getExe pkg;
          basename = builtins.baseNameOf exe;
          wrapper = pkgs.writeShellScriptBin basename ''
            WEBKIT_DISABLE_DMABUF_RENDERER=1 exec ${exe} "$@"
          '';
        in
        lib.hiPrio wrapper
      );
    in
    (with pkgs; [
      nur.repos.lonerOrz.qq
      wechat
      wemeet
      ayugram-desktop
      tor-browser
      qbittorrent-enhanced
      imfile
      nheko
      cherry-studio

      nur.repos.xddxdd.peerbanhelper
    ])
    # https://github.com/NixOS/nixpkgs/issues/424868
    ++ lib.optionals host.hostCfg.gpu.nvidia or false (
      nvFixWebkitGtk (
        with pkgs;
        [
          wechat
          ayugram-desktop
        ]
      )
    );

  imports = [
    ./firefox.nix
  ];
}
