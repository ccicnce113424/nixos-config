extraModules:
{ ... }:
{
  imports = [
    ./kernel.nix
    ./tweaks.nix
  ]
  ++ extraModules;
}
