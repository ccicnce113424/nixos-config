{ config, pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-zh-hans
      pkgs.vscode-extensions.ms-vscode.cpptools-extension-pack
    ];
    userSettings = {
      "files.autoGuessEncoding" = true;
      "security.workspace.trust.enabled" = false;
    };
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
