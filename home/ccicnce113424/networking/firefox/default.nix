{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    nativeMessagingHosts = with pkgs.kdePackages; [ plasma-browser-integration ];
    profiles = {
      default = {
        isDefault = true;
        settings = {
          "intl.locale.requested" = "zh-cn";
          "browser.tabs.closeTabByDblclick" = true;
          "browser.urlbar.keepPanelOpenDuringImeComposition" = true;
          "sidebar.animation.expand-on-hover.duration-ms" = 200;
          "sidebar.main.tools" = "history,bookmarks";
          "sidebar.verticalTabs" = true;
          "sidebar.visibility" = "expand-on-hover";
        };
        extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          violentmonkey
          foxyproxy-standard
          user-agent-string-switcher
          plasma-integration
          bilisponsorblock
          sponsorblock
          aria2-integration
          immersive-translate
          gesturefy
          scroll_anywhere
          search-by-image
          clearcache
          clearurls
          video-downloadhelper
          header-editor
          darkreader
          indie-wiki-buddy
          ruffle_rs
          floccus
          bitwarden
          cookies-txt
        ];
      };
    };
  };
}
