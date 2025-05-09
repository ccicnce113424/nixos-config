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

  home.packages = with pkgs; [
    android-tools
    scrcpy
  ];
  fonts.fontconfig.enable = true;

  xdg.desktopEntries = lib.mapAttrs (name: _: {
    inherit name;
    exec = name;
    terminal = true;
    comment = "run \"${name}\"";
  }) sysCfg.cmdAliases;
}
