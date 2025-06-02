{
  pkgs,
  lib,
  osConfig,
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

  fonts.fontconfig.enable = true;

  xdg.desktopEntries = lib.mapAttrs (name: _: {
    inherit name;
    exec = name;
    terminal = true;
    comment = "run \"${name}\"";
  }) osConfig.cmdAliases;

  home.packages = with pkgs; [
    bitwarden-desktop
    shijima-qt
  ];
}
