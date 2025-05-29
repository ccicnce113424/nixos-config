{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-ceintl.vscode-language-pack-zh-hans
      github.vscode-github-actions
      github.copilot
      skellock.just
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
