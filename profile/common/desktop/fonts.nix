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
      dejavu_fonts
      maple-mono.NF-CN
      nerd-fonts.symbols-only
      nur.repos.rewine.ttf-wps-fonts
      nur.repos.rewine.ttf-ms-win10
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Noto Sans CJK SC"
          "Noto Sans CJK"
          "Noto Sans"
          "Noto Color Emoji"
          "Noto Emoji"
          "Symbols Nerd Font"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Noto Serif CJK"
          "Noto Serif"
          "Noto Color Emoji"
          "Noto Emoji"
          "Symbols Nerd Font"
          "DejaVu Serif"
        ];
        monospace = [
          "Maple Mono NF CN"
          "Noto Sans Mono CJK SC"
          "Noto Sans Mono CJK"
          "Noto Color Emoji"
          "Noto Emoji"
          "DejaVu Sans Mono"
        ];
        emoji = [
          "Noto Color Emoji"
          "Noto Emoji"
          "Symbols Nerd Font"
          "Noto Sans CJK SC"
          "Noto Sans CJK"
          "Noto Sans"
          "DejaVu Sans"
        ];
      };
    } // lib.optionalAttrs config.enable32Bit { cache32Bit = true; };
  };
}
