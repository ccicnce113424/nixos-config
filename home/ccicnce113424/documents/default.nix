{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libreoffice-qt6-fresh
    hunspell
    hunspellDicts.en_US
    pdf4qt
    kdePackages.kcharselect

    wpsoffice-cn
  ];
}
