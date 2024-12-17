{ pkgs, ... }:
{
  home.packages = [
    pkgs.libreoffice-qt6-fresh
    pkgs.hunspell
    pkgs.hunspellDicts.en_US
  ];
  services.flatpak.packages = [ "org.onlyoffice.desktopeditors" ];
}
