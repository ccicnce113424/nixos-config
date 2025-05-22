{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nur.repos.guanran928.misans
  ];
}
