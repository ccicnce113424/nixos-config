{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };
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
