{ ... }:
{
  programs.plasma.enable = true;
  # programs.plasma.overrideConfig = true;
  programs.plasma.workspace.colorScheme = "BreezeDark";
  programs.plasma.panels = [ { floating = true; } ];
  imports = [ ./power.nix ];
}
