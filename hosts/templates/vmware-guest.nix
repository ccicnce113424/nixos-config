extraModules:
{ ... }:
{
  imports = [
    ./vm-guest.nix
    ../modules/vmware-guest.nix
  ] ++ extraModules;
}
