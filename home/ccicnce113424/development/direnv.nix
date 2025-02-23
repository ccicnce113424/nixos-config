{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.vscode.profiles.default.extensions = [ pkgs.vscode-extensions.mkhl.direnv ];
}
