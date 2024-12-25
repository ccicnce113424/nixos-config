extraModules:
{ ... }:
{
  imports = [
    ../modules/locale-time-cn.nix
    ../modules/vm-pipewire.nix
    ../modules/vmware-guest.nix
  ] ++ extraModules;
}
