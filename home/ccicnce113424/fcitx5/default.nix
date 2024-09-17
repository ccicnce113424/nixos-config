{ config, ... }:
{
  i18n.inputMethod.enabled = "fcitx5";
  # i18n.inputMethod.fcitx5 = {
  #   addons = with config.nur.repos.aleksana; [
  #     fcitx5-pinyin-cedict
  #     fcitx5-pinyin-chinese-idiom
  #     fcitx5-pinyin-moegirl
  #     fcitx5-pinyin-zhwiki
  #   ];
  # };
}
