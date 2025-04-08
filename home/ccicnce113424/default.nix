{ ... }:
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

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
