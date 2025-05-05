extraModules:
{ ... }:
{
  imports = [
    ./vm-guest.nix
    ../modules/vbox-guest.nix
  ] ++ extraModules;
}
