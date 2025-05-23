{ pkgs, ... }:
{
  networking = {
    firewall.enable = true;
    networkmanager.enable = true;
    iproute2.enable = true;
  };

  services.udev.extraRules = ''ACTION=="add", SUBSYSTEM=="net", NAME=="en*", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol g"'';

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
