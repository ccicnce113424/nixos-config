{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil
    nixd
    nixfmt-rfc-style
  ];
  programs.vscode = {
    profiles.default.extensions = with pkgs; [
      vscode-extensions.jnoortheen.nix-ide
      vscode-extensions.arrterian.nix-env-selector
    ];
    # userSettings = {
    #   "nix.enableLanguageServer" = true;
    #   "nix.serverPath" = "nixd";
    #   "nix.serverSettings" = {
    #     "nixd" = {
    #       "formatting" = {
    #         "command" = [ "nixfmt" ];
    #       };
    #     };
    #   };
    # };
  };
}
