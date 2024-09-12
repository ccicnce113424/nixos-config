{ config, pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    languagePackages = [ "zh-CN" ];
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
    wrapperConfig = {
      pipewireSupport = true;
    };
  };

  services.speechd.enable = true;

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}