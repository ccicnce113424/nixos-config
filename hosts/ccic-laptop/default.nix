{ ... }:
{
  imports = [
    ../templates/desktop.nix
    ./hardware-configuration.nix
  ];
  hostCfg = {
    cpu.amd = true;
    gpu.amdgpu = true;
    biometric.howdy = true;
  };
}
