{ pkgs, config, ... }:

{
  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = [
    config.nur.repos.xddxdd.vk-hdr-layer
    pkgs.kdePackages.kdeconnect-kde
    pkgs.dmidecode
  ];
  # environment.sessionVariables = {
  #   ENABLE_HDR_WSI = "1";
  # };
}
