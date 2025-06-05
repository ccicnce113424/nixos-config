let
  desktop-template = {
    system = "x86_64-linux";
    profile = "desktop";
    env = [
      "plasma"
      "image"
      "gaming"
      "obs"
      "virt-manager"
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
  livecd = thin // {
    profile = "livecd";
  };
  vbox-test = thin // {
    profile = "vm-test";
  };
  vmware-test = thin // {
    profile = "vm-test";
  };
}
