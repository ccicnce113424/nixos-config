extraModules:
{ ... }:
{
  imports = [
    ./audio.nix
    ./fonts.nix
    ./graphic.nix
    ./utils.nix
    ../minimal
  ]
  ++ extraModules;
}
