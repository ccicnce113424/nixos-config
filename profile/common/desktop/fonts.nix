{
  pkgs,
  config,
  lib,
  ...
}:
{
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
      dejavu_fonts
      maple-mono.NF-CN
      lxgw-wenkai-gb
      zhuque
      nerd-fonts.symbols-only
      nur.repos.rewine.ttf-wps-fonts
      nur.repos.rewine.ttf-ms-win10
    ];

    fontconfig = {
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
    } // lib.optionalAttrs config.enable32Bit { cache32Bit = true; };
  };
}
