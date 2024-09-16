{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixfmt-rfc-style
  ];
  programs.vscode = {
    extensions = [
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.arrterian.nix-env-selector
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };
    };
  };
}
