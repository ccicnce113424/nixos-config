{ pkgs, ... }:
{
  programs.difftastic = {
    enable = true;
    jujutsu.enable = true;
  };
  programs.mergiraf = {
    enable = true;
    enableGitIntegration = false;
    enableJujutsuIntegration = false;
  };
  home.packages = with pkgs; [ meld ];
}
