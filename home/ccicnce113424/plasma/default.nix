{
  pkgs,
  lib,
  osConfig,
  ...
}:
{
  programs.plasma = {
    enable = true;
    overrideConfig = true;

    panels = [
      {
        floating = true;
        widgets = [
          "org.kde.plasma.kickoff"
          "org.kde.plasma.pager"
          "org.kde.plasma.icontasks"
          "org.kde.plasma.marginsseparator"
          {
            name = pkgs.lyrica-plasmoid.passthru.id;
            config.Backend = {
              tlyricMode = 3;
            };
          }
          {
            name = "plasmusic-toolbar";
            config.General = {
              maxSongWidthInPanel = 150;
              showWhenNoMedia = false;
            };
          }
          {
            name = "luisbocanegra.audio.visualizer";
            config.General = {
              length = 100;
              noiseReduction = 15;
              hideWhenIdle = true;
              idleTimer = 3;
            };
          }
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
          "org.kde.plasma.showdesktop"
        ];
      }
    ];
    workspace.lookAndFeel = "org.kde.breezedark.desktop";

    fonts = rec {
      fixedWidth = {
        family = lib.head osConfig.fonts.fontconfig.defaultFonts.monospace;
        pointSize = 10;
      };
      general = {
        family = lib.head osConfig.fonts.fontconfig.defaultFonts.sansSerif;
        pointSize = 10;
      };
      small = {
        family = lib.head osConfig.fonts.fontconfig.defaultFonts.sansSerif;
        pointSize = 8;
      };
      menu = general;
      toolbar = general;
      windowTitle = general;
    };

    configFile = {
      kwinrc.Wayland.InputMethod = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
      ksmserverrc.General.loginMode = "restoreSavedSession";
      dolphinrc.IconsMode.IconSize = 64;

      # BALOO IS COMPLETELY GARBAGE
      baloofilerc."Basic Settings".Indexing-Enabled.value = false;
    };
  };

  home.packages = with pkgs; [
    lyrica-plasmoid
    kurve
    plasmusic-toolbar
    kdePackages.wallpaper-engine-plugin
  ];

  imports = [ ./power.nix ];
}
