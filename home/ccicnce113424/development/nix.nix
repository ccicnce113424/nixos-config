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
      flake-linter
    ])
    ++ (with osConfig.nixPackages; [
      nixpkgs-reviewFull
      nix-eval-jobs
      nix-fast-build
      nix-update
    ]);

  programs.zed-editor = {
    extensions = [ "nix" ];
    userSettings.languages.Nix.language_servers = [
      "nixd"
      "jj_lsp"
      "!nil"
      "..."
    ];
  };
}
