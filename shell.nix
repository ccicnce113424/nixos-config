{
  pkgs ? import <nixpkgs> { },
  ...
}:
pkgs.mkShell {
  packages = with pkgs; [
    just
    nixd
    nil
    nixfmt-rfc-style
    nix-tree
    nix-output-monitor
  ];
}
