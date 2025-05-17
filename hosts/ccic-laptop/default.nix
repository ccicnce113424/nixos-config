{ ... }:
{
  imports = [
    ../templates/desktop.nix
    ./hardware-configuration.nix
  ];
  hostCfg = {
    cpu = "amd";
    gpu.amdgpu = true;
  };
}
