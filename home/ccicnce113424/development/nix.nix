{ pkgs, osConfig, ... }:
{
  home.packages = builtins.attrValues {
    inherit (pkgs)
      nixd
      nixfmt-rs
      nix-tree
      nix-output-monitor
      hydra-check
      cachix
      flake-linter
      mvs
      ;

    inherit (osConfig.nixPackages)
      nixpkgs-reviewFull
      nix-eval-jobs
      nix-fast-build
      nix-update
      ;
  };

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
