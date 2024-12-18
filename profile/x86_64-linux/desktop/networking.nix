{ ... }:
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

  services.daed = {
    enable = true;
    openFirewall = {
      enable = true;
      port = 12345;
    };
    configDir = "/etc/daed";
    listen = "127.0.0.1:2023";
  };
}
