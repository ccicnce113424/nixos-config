{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gg-jj
  ];
  programs.zed-editor = {
    extensions = [ "jj-lsp" ];
    extraPackages = with pkgs; [ jj-lsp ];
  };

  programs.jujutsu = {
    enable = true;
    settings.user = {
      email = "ccicnce113424@gmail.com";
      name = "ccicnce113424";
    };
  };
}
