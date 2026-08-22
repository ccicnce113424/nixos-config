lib:
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
        "direnv"
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
  ccic-desktop = lib.recursiveUpdate desktop-template {
    hostCfg = {
      cpu.intel = true;
      gpu.nvidia = true;
    };
  };
  ccic-laptop = lib.recursiveUpdate desktop-template {
    hostCfg = {
      cpu.amd = true;
      gpu.amdgpu = true;
    };
    runtime.features = desktop-template.runtime.features ++ [ "gaze" ];
  };
  vbox-test = lib.recursiveUpdate thin-template {
    profile = "vm-test";
    runtime.profile = "vm-test";
  };
  vmware-test = lib.recursiveUpdate thin-template {
    profile = "vm-test";
    runtime.profile = "vm-test";
  };
}
