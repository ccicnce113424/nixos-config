{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    # package = pkgs.firefox-bin;
    nativeMessagingHosts = with pkgs; [
      kdePackages.plasma-browser-integration
      ff2mpv-rust
    ];
    profiles = {
      default = {
        isDefault = true;
        settings = {
          "intl.locale.requested" = "zh-CN";
          "browser.tabs.closeTabByDblclick" = true;
          "browser.urlbar.keepPanelOpenDuringImeComposition" = true;
          "sidebar.animation.expand-on-hover.duration-ms" = 200;
          "sidebar.main.tools" = "history,bookmarks";
          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "expand-on-hover";
          "sidebar.revamp" = true;
        };
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          violentmonkey
          foxyproxy-standard
          user-agent-string-switcher
          plasma-integration
          bilisponsorblock
          sponsorblock
          kiss-translator
          gesturefy
          scroll_anywhere
          search-by-image
          clearurls
          video-downloadhelper
          header-editor
          indie-wiki-buddy
          ruffle_rs
          floccus
          bitwarden
          cookies-txt
          nixpkgs-pr-tracker
          chrome-mask
          ff2mpv
          # bypass-paywalls-clean
        ];
      };
    };
  };
}
