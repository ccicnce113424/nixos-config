{ pkgs, ... }:
{
  home.packages = [
    pkgs.onlyoffice-bin
    pkgs.libreoffice-qt6-fresh
    pkgs.hunspell
    pkgs.hunspellDicts.en_US
  ];
}
