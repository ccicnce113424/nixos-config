{ config, pkgs, ... }:

{

  # Avoid Chinese in the directory names
  xdg.userDirs.enable = true;

  programs.home-manager.enable = true;
}