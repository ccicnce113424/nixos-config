{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nixd
    nil
    nixfmt
    nix-tree
    nix-output-monitor
    hydra-check
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
