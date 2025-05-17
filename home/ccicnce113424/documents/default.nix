{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.en_US

    nur.repos.novel2430.wpsoffice-cn
  ];
}
