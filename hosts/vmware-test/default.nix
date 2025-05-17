{ ... }:
{
  imports = [ ../templates/vm-guest.nix ];
  hostCfg.vm.vmware = true;
}
