{ ... }:
{
  hardware.amdgpu = {
    opencl.enable = true;
  };
  environment.variables = {
    AMD_DEBUG = "useaco";
  };
}
