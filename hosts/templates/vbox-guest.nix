extraModules:
{ ... }:
{
  imports = [
    ../modules/locale-time-cn.nix
    ../modules/vm-pipewire.nix
    ../modules/vbox-guest.nix
  ] ++ extraModules;
}
