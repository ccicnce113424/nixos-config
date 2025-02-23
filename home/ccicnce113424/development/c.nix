{ pkgs, ... }:
{
  programs.vscode = {
    profiles.default.extensions = with pkgs.vscode-extensions; [
      llvm-vs-code-extensions.vscode-clangd
      vadimcn.vscode-lldb
    ];
  };
  home.packages = with pkgs; [
    clang-tools
    pkg-config
  ];
}
