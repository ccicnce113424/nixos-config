{ ... }:
{
  programs.plasma.enable = true;
  # programs.plasma.overrideConfig = true;
  programs.plasma.workspace.colorScheme = "BreezeDark";
  programs.plasma.panels = [ { floating = true; } ];
  programs.plasma.input.keyboard.numlockOnStartup = "on";
  imports = [ ./power.nix ];
}
