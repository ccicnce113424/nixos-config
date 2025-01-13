{ pkgs, ... }:
{
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
          foxyproxy-standard
          user-agent-string-switcher
          plasma-integration
          bilisponsorblock
          sponsorblock
          aria2-integration
          auto-tab-discard
          immersive-translate
        ];
      };
    };
  };
}
