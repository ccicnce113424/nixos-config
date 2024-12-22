{ ... }:
{
  programs.firefox = {
    enable = true;
    languagePacks = [ "zh-CN" ];
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;
      "widget.use-xdg-desktop-portal.settings" = 1;
      "widget.use-xdg-desktop-portal.location" = 1;
      "widget.use-xdg-desktop-portal.open-uri" = 1;
      "media.ffmpeg.vaapi.enabled" = true;
    };
    # package = pkgs.wrapFirefox pkgs.firefox-unwrapped.override {
    #   jemallocSupport = false;
    # } { };
  };

  services.speechd.enable = true;

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
  };
}
