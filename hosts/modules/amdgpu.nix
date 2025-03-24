{ ... }:
{
  hardware.amdgpu = {
    opencl.enable = true;
    amdvlk = {
      enable = true;
      support32Bit.enable = true;
      supportExperimental.enable = true;
    };
  };
  environment.variables = {
    AMD_DEBUG = "useaco";
  };
}
