{ ... }:
{
  imports = [
    ../templates/desktop.nix
    ./hardware-configuration.nix
  ];
  hostCfg = {
    cpu.intel = true;
    gpu.nvidia = true;
  };
}
