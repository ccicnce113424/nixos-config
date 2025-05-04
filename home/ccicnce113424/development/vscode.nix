{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs; [
      vscode-extensions.ms-ceintl.vscode-language-pack-zh-hans
      vscode-extensions.github.vscode-github-actions
      vscode-extensions.github.copilot
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
