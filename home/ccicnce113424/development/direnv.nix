{ config, pkgs, ...}:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
  programs.vscode.extensions = [pkgs.vscode-extensions.mkhl.direnv];
}
