let
  desktop-template = {
    system = "x86_64-linux";
    profile = "desktop";
    env = [
      "plasma"
      "image"
      "gaming"
      "obs"
      "vbox"
      "wine"
    ];
    users = [ "ccicnce113424" ];
    thin = false;
  };
  thin = {
    system = "x86_64-linux";
    thin = true;
  };
in
{
  ccic-desktop = desktop-template // {
    hostCfg = {
      cpu.intel = true;
      gpu.nvidia = true;
    };
  };
  ccic-laptop = desktop-template // {
    hostCfg = {
      cpu.amd = true;
      gpu.amdgpu = true;
    };
  };
  vbox-test = thin // {
    profile = "vm-test";
  };
  vmware-test = thin // {
    profile = "vm-test";
  };
}
