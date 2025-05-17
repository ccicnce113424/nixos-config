{ ... }:
{
  imports = [
    ../modules/common.nix
    ../modules/vm.nix
  ];
  hostCfg.vm.enable = true;
}
