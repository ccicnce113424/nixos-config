{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      sarasa-gothic
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Noto Sans SC" ];
        serif = [ "Noto Serif SC" ];
        monospace = [
          "Hack"
          "Noto Sans SC"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
}
