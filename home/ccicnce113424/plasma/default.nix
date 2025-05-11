{ ... }:
{
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    workspace = {
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
    };
    panels = [ { floating = true; } ];
    input.keyboard.numlockOnStartup = "on";

    # BALOO IS A COMPLETE GARBAGE
    configFile.baloofilerc."Basic Settings".Indexing-Enabled.value = false;
  };

  imports = [ ./power.nix ];
}
