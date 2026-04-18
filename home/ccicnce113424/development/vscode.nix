{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans
      github.vscode-github-actions
      github.vscode-pull-request-github
      skellock.just
      yzhang.markdown-all-in-one
      yzane.markdown-pdf
      ms-vscode.live-server
      tomoki1207.pdf
      donjayamanne.githistory
    ];
  };
  # home.packages = with pkgs; [ vscode-runner ];
}
