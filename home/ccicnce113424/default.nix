{ osConfig, ... }:
{
  imports = [
    ./development
    ./multimedia
    ./networking
    ./plasma
    ./utils.nix
    ./documents
    ./zsh.nix
    ./inputs.nix
  ];

  # Avoid Chinese in the directory names
  xdg.userDirs.enable = true;

  home.stateVersion = osConfig.system.stateVersion;

  programs.home-manager.enable = true;
}
