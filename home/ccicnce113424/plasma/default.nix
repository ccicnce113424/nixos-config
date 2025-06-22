{ lib, osConfig, ... }:
{
  programs.plasma = {
    enable = true;
    overrideConfig = true;

    panels = [ { floating = true; } ];
    workspace.colorScheme = "BreezeDark";

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
      kdeglobals.KDE.LookAndFeelPackage = "org.kde.breezedark.desktop";
      ksmserverrc.General.loginMode = "restoreSavedSession";
      dolphinrc.IconsMode.IconSize = 64;

      # BALOO IS COMPLETELY GARBAGE
      baloofilerc."Basic Settings".Indexing-Enabled.value = false;
    };
  };

  imports = [ ./power.nix ];
}
