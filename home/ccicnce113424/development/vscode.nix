{ pkgs, ... }:

{
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
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
  home.file.".vscode/argv.json".text = builtins.toJSON {
    "enable-crash-reporter" = false;
    "locale" = "zh-cn";
  };
}
