{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override {
      jemallocSupport = false;
    }) {});
  };

  services.speechd.enable = true;

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}