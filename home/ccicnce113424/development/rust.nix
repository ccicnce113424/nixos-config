{ pkgs, ... }:
{
  programs.vscode = {
    profiles.default.extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
    ];
  };
}
