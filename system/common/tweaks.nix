{ pkgs, ... }:
{
  services.dbus.implementation = "broker";

  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix
  ];

  # environment.memoryAllocator.provider = "mimalloc";

  security.sudo.enable = false;
  security.sudo-rs.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;

  programs.nix-ld.enable = true;

  boot.kernelParams = [ "iommu=pt" ];

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
