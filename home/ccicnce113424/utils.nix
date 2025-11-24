{ pkgs, ... }:
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

  fonts.fontconfig.enable = false;

  home.packages = with pkgs; [
    bitwarden-desktop
    shijima-qt
  ];
}
