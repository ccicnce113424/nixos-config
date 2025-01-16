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
          "browser.tabs.closeTabByDblclick" = true;
          "browser.tabs.drawInTitlebar" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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
          gesturefy
          scroll_anywhere
          search-by-image
          clearcache
          clearurls
          video-downloadhelper
          header-editor

          tree-style-tab
          tst-indent-line
          tst-more-tree-commands
          tst-tab-search
          multiple-tab-handler
          move-unloaded-tabs-for-tst
        ];

        # https://github.com/piroor/treestyletab/wiki/Code-snippets-for-custom-style-rules#full-auto-showhide-theme
        # Need manually set tst style and set close tab by dbclick
        # TST options => "Development" => "All Configs" => "baseIndent" set to 8
        # Do not show tab preview image
        # TST tab search => Hide Header
        userChrome = builtins.readFile ./userChrome.css;
      };
    };
  };
}
