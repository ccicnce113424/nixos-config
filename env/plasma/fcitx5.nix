{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (builtins.elem "plasma" config.runtime.features) {
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
        settings = {
          addons = {
            classicui.globalSection = {
              Theme = "plasma";
              DarkTheme = "plasma";
              UseDarkTheme = true;
            };
          };
          inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "pinyin";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "pinyin";

            GroupOrder."1" = "English";
            "Groups/1" = {
              Name = "English";
              "Default Layout" = "us";
              DefaultIM = "keyboard-us";
            };
            "Groups/1/Items/0".Name = "keyboard-us";
          };
        };

        waylandFrontend = true;
      };
    };
  };
}
