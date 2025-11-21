{
  pkgs,
  lib,
  host,
  ...
}:
{
  home.packages =
    let
      nvFixWebkitGtk =
        list:
        if host.hostCfg.gpu.nvidia or false then
          map (
            pkg:
            let
              exe = lib.getExe pkg;
              basename = builtins.baseNameOf exe;
              wrapper = pkgs.writeShellScriptBin basename ''
                echo "NV webkit wrapper hit: $0 $@" >> /tmp/nv-webkit-wrapper.log
                export WEBKIT_DISABLE_DMABUF_RENDERER=1
                exec ${exe} "$@"
              '';
              desktopEntryWrapper = pkgs.runCommand "${basename}-desktop-entry-fix" { } ''
                mkdir -p $out/share/applications
                for entry in ${pkg}/share/applications/*.desktop; do
                  outEntry=$out/share/applications/$(basename "$entry")
                  # 简化处理：只在 Exec= 行中把命令名 ${basename} 替换为 wrapper 的可执行路径，保留其余环境变量和参数
                  # 例如：Exec=env FOO=1 ${basename} --flag %u
                  # 变为：Exec=env FOO=1 ${lib.getExe wrapper} --flag %u
                  sed -E 's#^(Exec=.*)\b${basename}\b(.*)$#\1${lib.getExe wrapper}\2#' "$entry" > "$outEntry"
                done
              '';
            in
            pkgs.buildEnv {
              name = "${basename}-nv-webkit-fix";
              paths = [
                pkg
                (lib.hiPrio wrapper)
                (lib.hiPrio desktopEntryWrapper)
              ];
            }
          ) list
        else
          list;
    in
    (with pkgs; [
      nur.repos.lonerOrz.qq
      wemeet
      tor-browser
      qbittorrent-enhanced
      imfile
      nheko
      cherry-studio

      nur.repos.xddxdd.peerbanhelper
    ])
    # https://github.com/NixOS/nixpkgs/issues/424868
    ++ (nvFixWebkitGtk (
      with pkgs;
      [
        wechat
        ayugram-desktop
      ]
    ));

  imports = [
    ./firefox.nix
  ];
}
