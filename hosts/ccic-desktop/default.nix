{ ... }:
{
  imports = [
    ../templates/desktop.nix
    ./hardware-configuration.nix
  ];
  hostCfg = {
    cpu = "intel";
    gpu.nvidia = true;
  };
}
