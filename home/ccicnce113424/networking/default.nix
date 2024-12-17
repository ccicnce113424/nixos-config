{ pkgs, ... }:
{
  programs.chromium.enable = true;
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs; [ kdePackages.plasma-browser-integration ];
    profiles = {
      default = {
        isDefault = true;
        settings = {
          "intl.locale.requested" = "zh-cn";
          "extensions.pocket.enabled" = false;
          "extensions.autoDisableScopes" = 0;
        };
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          violentmonkey
          smartproxy
          plasma-integration
        ];
      };
    };
  };

  home.packages = [
    pkgs.qq
    pkgs.wechat-uos
    pkgs.telegram-desktop
    pkgs.tor-browser
  ];
}
