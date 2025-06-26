{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.en_US
    pdf4qt

    nur.repos.fym998.wpsoffice-cn-fcitx
  ];
}
