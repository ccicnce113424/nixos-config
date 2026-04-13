let
  desktop-template = {
    system = "x86_64-linux";
    profile = "desktop";
    runtime = {
      profile = "desktop";
      homeManager = {
        enable = true;
      };
      features = [
        "plasma"
        "browsers"
        "image"
        "gaming"
        "obs"
        "vbox"
        "wine"
      ];
      users = [ "ccicnce113424" ];
    };
  };
  thin-template = {
    system = "x86_64-linux";
    runtime = {
      profile = "minimal";
      homeManager = {
        enable = false;
      };
      users = [ ];
    };
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
  vbox-test = thin-template // {
    profile = "vm-test";
    runtime.profile = "vm-test";
  };
  vmware-test = thin-template // {
    profile = "vm-test";
    runtime.profile = "vm-test";
  };
}
