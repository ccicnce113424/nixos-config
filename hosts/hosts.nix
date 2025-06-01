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
    env = null;
    users = null;
    thin = true;
  };
in
{
  ccic-desktop = desktop-template;
  ccic-laptop = desktop-template;
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
