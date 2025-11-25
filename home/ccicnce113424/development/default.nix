{ pkgs, ... }:
{
  imports = [
    ./vscode.nix
    ./nix.nix
    ./direnv.nix
    ./c.nix
    ./rust.nix
  ];
  home.packages = with pkgs; [
    just
    gh
  ];
}
