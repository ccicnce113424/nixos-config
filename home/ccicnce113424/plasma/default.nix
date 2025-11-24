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

    panels = [ { floating = true; } ];
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
    lyrica
    kurve
  ];

  imports = [ ./power.nix ];
}
