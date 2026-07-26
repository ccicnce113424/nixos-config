{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
  };

  programs.zed-editor.extensions = [ "git-firefly" ];
}
