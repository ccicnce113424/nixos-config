{ config, pkgs, ... }:

{
  networking = {
    networkmanager.enable = true;
    iproute2.enable = true;
  };

  services.samba.enable = true;
  services.samba.openFirewall = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      userServices = true;
    };
  };
}