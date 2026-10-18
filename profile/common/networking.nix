{ pkgs, ... }:
{
  networking = {
    firewall.enable = true;
    nftables.enable = true;
    iproute2.enable = true;
  };

  networking.networkmanager = {
    enable = true;
    wifi.backend = "wpa_supplicant";
  };

  services.firewalld.enable = true;

  # services.daed = {
  #   enable = true;
  #   package = pkgs.daed;
  #   openFirewall = {
  #     enable = true;
  #     port = 12345;
  #   };
  #   configDir = "/etc/daed";
  #   listen = "127.0.0.1:2023";
  # };

  # services.daed-next = {
  #   enable = true;
  #   package = pkgs.daed-next-git;
  #   configDir = "/etc/daed-next";
  #   stateDir = "/var/lib/daed-next";
  # };

  services.honk-core = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    inetutils
    sshfs
    nixos-firewall-tool
  ];
}
