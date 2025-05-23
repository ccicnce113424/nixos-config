{ pkgs, ... }:
{
  networking = {
    firewall.enable = true;
    networkmanager.enable = true;
    iproute2.enable = true;
  };

  networking.networkmanager.connectionConfig = {
    "ethernet.wake-on-lan" = "magic";
    "wifi.wake-on-lan" = "magic";
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

  environment.systemPackages = with pkgs; [
    inetutils
    sshfs
  ];
}
