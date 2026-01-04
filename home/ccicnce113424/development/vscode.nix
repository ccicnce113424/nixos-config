{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans
      github.vscode-github-actions
      github.copilot
      github.copilot-chat
      github.vscode-pull-request-github
      skellock.just
      yzhang.markdown-all-in-one
      yzane.markdown-pdf
      ms-vscode.live-server
      tomoki1207.pdf
    ];
    # userSettings = {
    #   "files.autoGuessEncoding" = true;
    #   "security.workspace.trust.enabled" = false;
    # };
  };
  # home.file.".vscode/argv.json".text = builtins.toJSON {
  #   "enable-crash-reporter" = false;
  #   "locale" = "zh-cn";
  # };
}
