{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.en_US

    nur.repos.chillcicada.wpsoffice-cn
  ];
}
