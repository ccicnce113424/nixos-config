{ pkgs, ... }:
{
  services.dbus.implementation = "broker";

  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix
    coreutils-prefixed
    bcachefs-tools
  ];

  # environment.memoryAllocator.provider = "mimalloc";

  security = {
    sudo.enable = false;
    sudo-rs.enable = true;
    rtkit.enable = true;
    polkit.enable = true;
  };

  programs.nix-ld.enable = true;

  boot = {
    kernelParams = [ "iommu=pt" ];
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      "net.core.default_qdisc" = "cake";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };

  users.groups.plugdev = { };
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", MODE="0664", GROUP="plugdev"
    SUBSYSTEM=="hidraw", MODE="0664", GROUP="plugdev"
  '';

  systemd.oomd.extraConfig = {
    DefaultMemoryPressureThreshold = "90%";
    DefaultMemoryPressureDurationSec = "10s";
  };
}
