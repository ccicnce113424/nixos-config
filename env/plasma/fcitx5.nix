{ pkgs, ... }:
{
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5 = {
    plasma6Support = true;
    addons = with pkgs; [ qt6Packages.fcitx5-chinese-addons ];
  };
}
