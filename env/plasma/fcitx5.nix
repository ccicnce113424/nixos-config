{ pkgs, config, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      plasma6Support = true;
      addons =
        (with pkgs; [ qt6Packages.fcitx5-chinese-addons ])
        ++ (with config.nur.repos.aleksana; [
          fcitx5-pinyin-cedict
          fcitx5-pinyin-chinese-idiom
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-zhwiki
        ]);
      settings.addons.classicui.globalSection = {
        Theme = "plasma";
        DarkTheme = "plasma";
        UseDarkTheme = "True";
      };
    };
  };
}
