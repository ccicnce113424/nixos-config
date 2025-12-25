{ pkgs, lib, ... }:
{
  services.dbus.implementation = "broker";
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  environment.systemPackages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix)
    coreutils-prefixed
    ntfsprogs-plus
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
    supportedFilesystems.bcachefs = true;
  };

  systemd.oomd.settings.OOM = {
    DefaultMemoryPressureThreshold = "60%";
    DefaultMemoryPressureDurationSec = "10s";
  };
}
