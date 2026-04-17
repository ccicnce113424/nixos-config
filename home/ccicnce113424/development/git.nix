{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  programs.zed-editor.extensions = [ "git-firefly" ];

  home.packages = with pkgs; [
    github-copilot-cli
  ];
}
