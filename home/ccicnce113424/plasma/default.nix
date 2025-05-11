{ ... }:
{
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    input.keyboard.numlockOnStartup = "on";
    panels = [ { floating = true; } ];

    configFile = {
      kwinrc.Wayland.InputMethod = "/run/current-system/sw/share/applications/org.fcitx.Fcitx5.desktop";
      kdeglobals.KDE.LookAndFeelPackage = "org.kde.breezedark.desktop";
      ksmserverrc.General.loginMode = "restoreSavedSession";
      dolphinrc.IconsMode.IconSize = 64;

      # BALOO IS A COMPLETE GARBAGE
      baloofilerc."Basic Settings".Indexing-Enabled.value = false;
    };
  };

  imports = [ ./power.nix ];
}
