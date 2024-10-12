{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-zh-hans
      pkgs.vscode-extensions.ms-vscode.cpptools
    ];
    # userSettings = {
    #   "files.autoGuessEncoding" = true;
    #   "security.workspace.trust.enabled" = false;
    # };
  };
  home.file.".vscode/argv.json".text = builtins.toJSON {
    "enable-crash-reporter" = false;
    "locale" = "zh-cn";
  };
}
