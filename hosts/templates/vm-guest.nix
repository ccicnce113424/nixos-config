{ ... }:
{
  imports = [
    ../modules/desktop.nix
    ../modules/vm.nix
    ../modules/locale.nix
  ];
  hostCfg.vm.enable = true;
}
