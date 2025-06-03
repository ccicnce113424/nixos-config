{ pkgs, ... }:
{
  imports = [
    ./vscode.nix
    ./nix.nix
    ./direnv.nix
    ./c.nix
  ];
  home.packages = with pkgs; [
    just
    gh
  ];
}
