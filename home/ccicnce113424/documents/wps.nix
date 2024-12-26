{ pkgs, lib, ... }:
let
  # https://github.com/NixOS/nixpkgs/pull/280541
  wps = (
    pkgs.wpsoffice-cn.overrideAttrs (
      finalAttrs: previousAttrs: rec {
        freetype-wps = pkgs.freetype.overrideAttrs (old: {
          pname = "freetype-wps";
          version = "2.13.0";
          src = pkgs.fetchurl {
            url = "mirror://savannah/freetype/freetype-2.13.0.tar.xz";
            hash = "sha256-XuI6vQR2NsJLLUPGYl3K/GZmHRrKZN7J4NBd8pWSYkw=";
          };
        });
        preFixup =
          ''
            ln -s ${freetype-wps}/lib/libfreetype.so.* $out/opt/kingsoft/wps-office/office6/
          ''
          + previousAttrs.preFixup;
      }
    )
  );
in
{
  home.packages = [ wps ];

  home.activation.fixWPSIM = lib.hm.dag.entryAfter [ "xdg" ] ''
    mkdir -p ~/.local/share/applications
    for file in ${wps}/share/applications/*.desktop; do
      basefile=$(basename "$file")
      target_file="$HOME/.local/share/applications/$basefile"
      cp -f "$file" "$target_file"
      sed -i 's|^Exec=|Exec=env QT_IM_MODULE=fcitx5 |' "$target_file"
    done
  '';
}
