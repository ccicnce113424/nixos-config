{ pkgs, ... }:
{
  home.packages = [
    pkgs.onlyoffice-bin
    pkgs.libreoffice-qt-fresh
    pkgs.hunspell
    pkgs.hunspellDicts.en_US
  ];
}
