{ config, pkgs, ... }:
{
  programs.chromium.enable = true;
  programs.firefox.enable = true;
  programs.firefox.profiles = {
    default = {
      isDefault = true;
      settings = {
        "intl.locale.requested" = "zh-cn";
        "extensions.pocket.enabled" = false;
        "extensions.autoDisableScopes" = 0;
      };
      extensions = with config.nur.repos.rycee.firefox-addons; [
        ublock-origin
        violentmonkey
        smartproxy
      ];
    };
  };

  home.packages = [
    pkgs.qq
    config.nur.repos.xddxdd.wechat-uos
  ];
}
