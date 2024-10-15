{ pkgs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = [
      pkgs.vscode-extensions.ms-ceintl.vscode-language-pack-zh-hans
    ];
    userSettings = {
      "files.autoGuessEncoding" = true;
      "security.workspace.trust.enabled" = false;
    };
  };
  home.file.".vscode/argv.json".text = builtins.toJSON {
    "enable-crash-reporter" = false;
    "locale" = "zh-cn";
  };
}
