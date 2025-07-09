{ pkgs, ... }:
{
  programs.thunderbird = {
    enable = true;
    nativeMessagingHosts = with pkgs.kdePackages; [ plasma-browser-integration ];
    settings = {
      # Settings for integration
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;
      "widget.use-xdg-desktop-portal.settings" = 1;
      "widget.use-xdg-desktop-portal.location" = 1;
      "widget.use-xdg-desktop-portal.open-uri" = 1;
      "widget.use-xdg-desktop-portal.native-messaging" = 1;

      "mail.accounthub.enabled" = true;
    };

    profiles.default.isDefault = true;
  };
}
