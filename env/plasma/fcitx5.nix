{ pkgs, ... }:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      addons =
        with pkgs;
        [
          qt6Packages.fcitx5-chinese-addons
          qt6Packages.fcitx5-configtool
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-zhwiki
          fcitx5-pinyin-minecraft
          fcitx5-lua
        ]
        ++ (with pkgs.nur.repos.aleksana; [
          fcitx5-pinyin-cedict
          fcitx5-pinyin-chinese-idiom
        ]);
      settings.addons.classicui.globalSection = {
        Theme = "plasma";
        DarkTheme = "plasma";
        UseDarkTheme = "True";
      };

      waylandFrontend = true;
    };
  };
}
