{ pkgs, ... }:
{
  home.packages = with pkgs; [
    heroic
    gogdl
  ];
}
