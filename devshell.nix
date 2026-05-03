{ pkgs, ... }:
pkgs.mkShellNoCC {
  preferLocalBuild = true;
  allowSubstitutes = false;
  packages = with pkgs; [
    just
    nixd
  ];
}
