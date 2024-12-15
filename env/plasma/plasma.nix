{ pkgs, ... }:

{
  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = [
    pkgs.nur.repos.xddxdd.vk-hdr-layer
    pkgs.kdePackages.kdeconnect-kde
    pkgs.dmidecode
    pkgs.kdePackages.plasma-disks
    pkgs.kdePackages.krdc
    pkgs.kdePackages.krfb
  ];

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
