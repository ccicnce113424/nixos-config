let
  desktop-template = {
    system = "x86_64-linux";
    profile = "desktop";
    env = [
      "plasma"
      "gaming"
      "obs"
      "virt-manager"
      "wine"
    ];
    users = [ "ccicnce113424" ];
  };
  thin = {
    system = "x86_64-linux";
    env = null;
    users = null;
  };
in
{
  ccic-desktop = desktop-template;
  ccic-laptop = desktop-template;
  livecd = thin // {
    profile = "livecd";
  };
  vbox-test = thin // {
    profile = "desktop";
  };
  vmware-test = thin // {
    profile = "desktop";
  };
}
