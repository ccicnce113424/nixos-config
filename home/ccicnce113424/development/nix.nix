{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nil
    nixfmt-rfc-style
    nix-tree
    nix-output-monitor
  ];
  programs.vscode = {
    profiles.default.extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
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
