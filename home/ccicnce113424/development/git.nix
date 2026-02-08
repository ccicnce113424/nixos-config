{ ... }:
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
}
