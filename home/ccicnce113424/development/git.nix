{ pkgs, ... }:
{
  programs.git.enable = true;
  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      diffToolMode = true;
    };
  };
  programs.mergiraf.enable = true;

  programs.zed-editor.extensions = [ "git-firefly" ];

  home.packages = with pkgs; [
    github-copilot-cli
  ];
}
