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
in
{
  ccic-desktop = desktop-template;
  ccic-laptop = desktop-template;
  livecd = {
    system = "x86_64-linux";
    profile = "livecd";
    env = null;
    users = null;
  };
}
