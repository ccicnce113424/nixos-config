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
    publich = {
      enable = true;
      userServices = true;
    };
  };
}