{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gg-jj
  ];
  programs.difftastic.jujutsu.enable = true;
  programs.mergiraf.enableJujutsuIntegration = true;
  programs.zed-editor.extensions = [ "jj-lsp" ];

  programs.jujutsu = {
    enable = true;
    settings.user = {
      email = "ccicnce113424@gmail.com";
      name = "ccicnce113424";
    };
  };
}
