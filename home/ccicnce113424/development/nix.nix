{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nil
    nixd
    nixfmt-rfc-style
  ];
  programs.vscode = {
    extensions = [
      pkgs.vscode-extensions.jnoortheen.nix-ide
      pkgs.vscode-extensions.arrterian.nix-env-selector
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };
    };
  };
}
