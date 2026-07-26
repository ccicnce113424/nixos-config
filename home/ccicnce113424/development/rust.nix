{ ... }:
{
  programs.zed-editor.userSettings.lsp."rust-analyzer"."initialization_options".check.command =
    "clippy";
}
