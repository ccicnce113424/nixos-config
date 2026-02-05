{ pkgs, ... }:
{
  home.packages =
    (with pkgs; [
      nixd
      nixfmt
      nix-tree
      nix-output-monitor
      hydra-check
    ])
    ++ (with pkgs.lixPackageSets.stable; [
      nixpkgs-review
      nix-eval-jobs
      nix-fast-build
      nix-update
    ]);
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
