{ pkgs, ... }:
{
  services.dbus.implementation = "broker";
  services.scx.enable = true;

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
  };

  systemd.oomd.extraConfig = {
    DefaultMemoryPressureThreshold = "60%";
    DefaultMemoryPressureDurationSec = "10s";
  };
}
