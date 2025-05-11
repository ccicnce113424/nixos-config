{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;
  environment.systemPackages = with pkgs; [
    dmidecode
    kdePackages.plasma-disks
    kdePackages.krdc
    kdePackages.krfb
    kdePackages.qtmultimedia
    kdePackages.qtwebengine
    kdePackages.yakuake
    kdePackages.francis
    kdePackages.kcalc
    kdePackages.kclock
    kdePackages.kweather
    kdePackages.filelight
    kdePackages.kfind
    kdePackages.wallpaper-engine-plugin

    nur.repos.xddxdd.vk-hdr-layer
  ];

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
             action.id == "org.freedesktop.udisks.filesystem-mount-system-internal") &&
            subject.local && subject.active && subject.isInGroup("users"))
        {
                return polkit.Result.YES;
        }
    });
  '';

  networking.firewall = {
    allowedTCPPorts = [
      3389
      5900
    ];
    allowedUDPPorts = [
      3389
      5900
    ];
  };
  # environment.sessionVariables = {
  #   ENABLE_HDR_WSI = "1";
  # };
}
