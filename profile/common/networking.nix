{ pkgs, ... }:
{
  networking = {
    firewall.enable = true;
    nftables.enable = true;
    networkmanager.enable = true;
    iproute2.enable = true;
  };

  services.firewalld.enable = true;

  services.daed = {
    enable = true;
    package = pkgs.daed;
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
    nixos-firewall-tool
  ];

  services.chrony = {
    enable = true;
    extraFlags = [ "-s" ];
    enableRTCTrimming = true;
    autotrimThreshold = 1;
    makestep.enable = true;
    dispatcherScript = true;
  };

  # remove this when changes are merged upstream
  disabledModules = [ "services/networking/ntp/chrony.nix" ];
  imports = [ ./chrony.nix ];
}
