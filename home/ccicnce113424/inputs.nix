{ pkgs, ... }:
{
  programs.lan-mouse = {
    enable = true;
    package = pkgs.lan-mouse;
  };
}
