{ pkgs, ... }:
{
  imports = [
    ./vscode.nix
    ./nix.nix
    ./direnv.nix
    ./c.nix
    ./rust.nix
    ./git.nix
    ./zed.nix
  ];
  home.packages = with pkgs; [
    just
    gh
  ];
}
