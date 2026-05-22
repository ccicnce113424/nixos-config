{ pkgs, osConfig, ... }:
{
  home.packages =
    (with pkgs; [
      nixd
      nixfmt-rs
      nix-tree
      nix-output-monitor
      hydra-check
      cachix
    ])
    ++ (with osConfig.nixPackages; [
      nixpkgs-reviewFull
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

  programs.zed-editor = {
    extensions = [ "nix" ];
    userSettings.languages.Nix.language_servers = [
      "nixd"
      "!nil"
    ];
  };
}
