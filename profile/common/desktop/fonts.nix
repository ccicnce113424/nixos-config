{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.runtime.profile == "desktop") {
    fonts = {
      enableDefaultPackages = true;
      fontDir.enable = true;
      packages = with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-color-emoji
        noto-fonts-monochrome-emoji
        noto-fonts-lgc-plus
        noto-fonts-emoji-blob-bin
        dejavu_fonts
        maple-mono.NF-CN
        arphic-ukai
        lxgw-wenkai-gb
        zhuque
        nerd-fonts.symbols-only
        nur.repos.chillcicada.ttf-wps-fonts
        nur.repos.chillcicada.ttf-ms-win10
        nur.repos.chillcicada.ttf-ms-win10-sc-sup
        nur.repos.chillcicada.font-office
      ];

      fontconfig = rec {
        includeUserConf = false;
        subpixel.rgba = "rgb";
        hinting.style = "slight";
        defaultFonts = {
          sansSerif = [
            "Noto Sans"
            "Noto Sans CJK SC"
            "Noto Color Emoji"
            "Noto Emoji"
            "Symbols Nerd Font"
            "DejaVu Sans"
          ];
          serif = [
            "Noto Serif"
            "Noto Serif CJK SC"
            "Noto Color Emoji"
            "Noto Emoji"
            "Symbols Nerd Font"
            "DejaVu Serif"
          ];
          monospace = [
            "Maple Mono NF CN"
            "Noto Sans Mono"
            "Noto Sans Mono CJK SC"
            "Noto Color Emoji"
            "Noto Emoji"
            "DejaVu Sans Mono"
          ];
          emoji = [
            "Noto Color Emoji"
            "Noto Emoji"
            "Symbols Nerd Font"
            "Noto Sans"
            "Noto Sans CJK SC"
            "DejaVu Sans"
          ];
        };
        aliases = {
          "ui-sans-serif".prefer = defaultFonts.sansSerif;
          "ui-serif".prefer = defaultFonts.serif;
          "ui-monospace".prefer = defaultFonts.monospace;
          "system-ui".prefer = defaultFonts.sansSerif;
          "-apple-system".prefer = defaultFonts.sansSerif;
        };
        cache32Bit = lib.mkIf config.enable32Bit true;
      };
    };
  };
}
