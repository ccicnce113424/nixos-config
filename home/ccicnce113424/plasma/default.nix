{ ... }:
{
  programs.plasma = {
    enable = true;
    overrideConfig = true;

    panels = [ { floating = true; } ];
    workspace.colorScheme = "BreezeDark";

    input = {
      keyboard.numlockOnStartup = "on";
      touchpads = [
        {
          vendorId = "04f3";
          productId = "3202";
          name = "ELAN06FA:01 04F3:3202 Touchpad";
          naturalScroll = true;
        }
      ];
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
