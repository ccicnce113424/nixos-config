{ pkgs, ... }:
{
  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;
  environment.systemPackages =
    with pkgs;
    [
      dmidecode
      qpwgraph
      smartmontools
      lm_sensors
    ]
    ++ (with pkgs.kdePackages; [
      plasma-disks
      krdc
      krfb
      qtmultimedia
      qtwebengine
      yakuake
      kcalc
      kclock
      kweather
      filelight
      kfind
      kdialog
      sddm-kcm
    ]);

  programs.kde-pim = {
    enable = true;
    kmail = true;
    kontact = true;
    merkuro = true;
  };

  # https://gist.github.com/Scrumplex/8f528c1f63b5f4bfabe14b0804adaba7
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if (subject.isInGroup("wheel")) {
            if (action.id.startsWith("org.freedesktop.udisks2.")) {
                return polkit.Result.YES;
            }
        }
    });
  '';

  # Open port for remote control
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
