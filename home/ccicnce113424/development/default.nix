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
  home.packages = with pkgs; [
    just
    gh
    shellcheck
    llm-agents.opencode
    llm-agents.mimo-code
  ];
}
