{ ... }:
{
  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      diffToolMode = true;
    };
  };
  programs.mergiraf = {
    enable = true;
    enableGitIntegration = true;
  };
}
