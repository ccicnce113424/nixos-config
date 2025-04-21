{ ... }:
{
  hardware.amdgpu = {
    opencl.enable = true;
  };
  environment.variables = {
    AMD_DEBUG = "useaco";
  };
  nixpkgs.config.rocmSupport = true;
}
