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
        sans = [ "Source Han Sans CN" ];
        sansSerif = [ "Source Han Serif CN" ];
        monospace = [ "Sarasa Mono SC" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}