{ pkgs, ... }:
{
  fonts.fontconfig.enable = false;

  home.packages = with pkgs; [
    shijima-qt
    kdePackages.francis
    kdePackages.skanpage
    winboat
  ];
}
