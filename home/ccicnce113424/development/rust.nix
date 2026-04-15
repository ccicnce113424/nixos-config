{ pkgs, ... }:
{
  programs.vscode = {
    profiles.default.extensions = with pkgs.vscode-extensions; [
      rust-lang.rust-analyzer
    ];
  };

  programs.zed-editor.userSettings.lsp."rust-analyzer"."initialization_options".check.command =
    "clippy";
}
