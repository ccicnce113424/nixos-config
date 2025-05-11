{ sysCfg, ... }:
{
  imports = [
    ./development
    ./multimedia
    ./networking
    ./plasma
    ./utils.nix
    ./documents
    ./zsh.nix
    ./fonts.nix
  ];

  # Avoid Chinese in the directory names
  xdg.userDirs.enable = true;

  home.stateVersion = sysCfg.system.stateVersion;

  programs.home-manager.enable = true;
}
