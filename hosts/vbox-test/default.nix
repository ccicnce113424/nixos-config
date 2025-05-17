{ ... }:
{
  imports = [ ../templates/vm-guest.nix ];
  hostCfg.vm.type = "vbox";
}
