{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      dejavu_fonts
      hack-font
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Noto Sans SC"
          "Noto Sans"
          "Noto Color Emoji"
          "Noto Emoji"
          "DejaVu Sans"
        ];
        serif = [
          "Noto Serif SC"
          "Noto Serif"
          "Noto Color Emoji"
          "Noto Emoji"
          "DejaVu Serif"
        ];
        monospace = [
          "Hack"
          "Noto Sans SC"
          "Noto Sans"
          "Noto Color Emoji"
          "Noto Emoji"
          "DejaVu Sans Mono"
        ];
        emoji = [
          "Noto Color Emoji"
          "Noto Emoji"
          "DejaVu Sans"
        ];
      };
    };
  };
}
