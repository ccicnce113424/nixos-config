{ config, pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      sarasa-gothic
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Source Han Sans SC" ];
        serif = [ "Source Han Serif SC" ];
        monospace = [ "Sarasa Mono SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}