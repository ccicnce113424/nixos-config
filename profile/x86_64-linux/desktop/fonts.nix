{ pkgs, ... }:

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
      hack-font
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Noto Sans CJK SC"
          "Noto Sans CJK"
          "Noto Sans"
          "Noto Color Emoji"
          "Noto Emoji"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif CJK SC"
          "Noto Serif CJK"
          "Noto Serif"
          "Noto Color Emoji"
          "Noto Emoji"
          "DejaVu Serif"
        ];
        monospace = [
          "Hack"
          "Noto Sans CJK SC"
          "Noto Sans CJK"
          "Noto Sans"
          "Noto Color Emoji"
          "Noto Emoji"
          "DejaVu Sans Mono"
        ];
        emoji = [
          "Noto Color Emoji"
          "Noto Emoji"
          "Noto Sans CJK SC"
          "Noto Sans CJK"
          "Noto Sans"
          "DejaVu Sans"
        ];
      };
    };
  };
}
