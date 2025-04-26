{
  pkgs,
  lib,
  sysCfg,
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

  xdg.desktopEntries = lib.mapAttrs (name: _: {
    inherit name;
    exec = name;
    terminal = true;
    categories = [ "Utility" ];
    comment = "run \"${name}\"";
  }) sysCfg.shellAliases;
}
