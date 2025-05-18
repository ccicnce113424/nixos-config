{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.en_US

    wpsoffice-365
  ];
}
