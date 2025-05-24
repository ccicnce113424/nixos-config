{ pkgs, ... }:
{
  imports = [
    ./vscode.nix
    ./nix.nix
    ./direnv.nix
    ./git.nix
    ./c.nix
  ];
  home.packages = with pkgs; [ just ];
}
