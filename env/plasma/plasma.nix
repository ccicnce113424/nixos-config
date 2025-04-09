{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = [
    pkgs.kdePackages.kdeconnect-kde
    pkgs.dmidecode
    pkgs.kdePackages.plasma-disks
    pkgs.kdePackages.krdc
    pkgs.kdePackages.krfb
    pkgs.kdePackages.qtmultimedia
    pkgs.kdePackages.qtwebengine
    pkgs.kdePackages.yakuake
    pkgs.kdePackages.francis
    pkgs.kdePackages.kcalc
    pkgs.kdePackages.kclock
    pkgs.kdePackages.kweather
    pkgs.kdePackages.filelight
    pkgs.kdePackages.kfind
    pkgs.kdePackages.wallpaper-engine-plugin

    pkgs.nur.repos.xddxdd.vk-hdr-layer
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
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
  };
  # environment.sessionVariables = {
  #   ENABLE_HDR_WSI = "1";
  # };
}
