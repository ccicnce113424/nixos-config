{ pkgs, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config.whitelist.prefix = [ "~/code" ];
  };
  programs.vscode.profiles.default.extensions = with pkgs.vscode-extensions; [ mkhl.direnv ];
}
