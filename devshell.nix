{ pkgs, ... }:
pkgs.mkShell.override { stdenv = pkgs.stdenvNoCC; } {
  packages = with pkgs; [
    just
    nixd
    nil
    nixfmt
    nix-tree
    nix-output-monitor
  ];
}
