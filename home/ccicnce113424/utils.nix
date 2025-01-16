{
  pkgs,
  ...
}:
{
  services.flatpak = {
    enable = true;
    update.onActivation = true;
    # remotes = [
    #   {
    #     name = "flathub";
    #     location = "https://mirror.sjtu.edu.cn/flathub";
    #   }
    # ];
    uninstallUnmanaged = true;
  };

  home.packages = [
    pkgs.android-tools
    pkgs.scrcpy
  ];
  fonts.fontconfig.enable = true;
}
