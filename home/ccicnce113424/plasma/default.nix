{ inputs, host, ... }:
{
  programs.plasma.enable = true;
  # programs.plasma.overrideConfig = true;
  programs.plasma.workspace.colorScheme = "BreezeDark";
  programs.plasma.panels = [ { floating = true; } ];
  programs.plasma.input.keyboard.numlockOnStartup = "on";
  imports = [ ./power.nix ];

  # Wallpaper Engine
  home.packages = [ inputs.macronova.packages.${host.system}.wallpaper-engine-plasma6-plugin ];
}
