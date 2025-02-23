{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = [
      pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-zh-hans
      pkgs.vscode-extensions.github.vscode-github-actions
      pkgs.vscode-extensions.github.copilot
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
