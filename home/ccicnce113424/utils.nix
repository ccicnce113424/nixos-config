{ ... }:
{
  services.flatpak = {
    enable = true;
    remotes = [
      {
        name = "flathub";
        location = "https://mirror.sjtu.edu.cn/flathub";
      }
    ];
    packages = [
      "io.github.peazip.PeaZip"
    ];
    # uninstallUnmanaged = true;
  };
}
