{ ... }:
{
  imports = [ ../templates/vm-guest.nix ];
  hostCfg.vm.vbox = true;
}
