{ pkgs, ... }:
{
  imports = [
    ./nix.nix
    ./diff-tools.nix
    ./rust.nix
    ./git.nix
    ./jujutsu.nix
    ./zed.nix
    ./web.nix
  ];
  home.packages = builtins.attrValues {
    inherit (pkgs)
      just
      gh
      shellcheck
      ;
    # llm-agents.mimo-code
    # llm-agents.cc-switch-cli
    # llm-agents.codex
    inherit (pkgs.llm-agents)
      reasonix
      omp
      ;
  };
}
