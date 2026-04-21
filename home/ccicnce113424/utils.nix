{ pkgs, ... }:
{
  fonts.fontconfig.enable = false;

  home.packages = with pkgs; [
    bitwarden-desktop
    shijima-qt
    kdePackages.francis
    kdePackages.skanpage
    winboat
  ];
}
