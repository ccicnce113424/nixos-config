{ osConfig, ... }:
{
  imports = [
    ./development
    ./multimedia
    ./networking
    ./plasma
    ./inputs
    ./utils.nix
    ./documents
    ./zsh.nix
    ./gaming.nix
  ];

  # Avoid Chinese in the directory names
  xdg.userDirs.enable = true;

  home.stateVersion = osConfig.system.stateVersion;

  programs.home-manager.enable = true;
}
