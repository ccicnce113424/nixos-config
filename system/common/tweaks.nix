{ pkgs, lib, ... }:
{
  services.dbus.implementation = "broker";
  services.scx = {
    enable = true;
    scheduler = "scx_lavd";
  };

  environment.systemPackages = with pkgs; [
    (lib.hiPrio uutils-coreutils-noprefix)
    (lib.hiPrio uutils-findutils)
    (lib.hiPrio uutils-diffutils)
    (lib.hiPrio uutils-sed)
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
    supportedFilesystems = [
      "btrfs"
      "ext4"
      "f2fs"
      "xfs"
      "vfat"
      # "ntfs"  we use ntfsprogs-plus package instead
      "bcachefs"
    ];
    initrd.systemd.enable = true;
  };

  services.userborn.enable = true;

  system = {
    etc.overlay.enable = true;
    nixos-init.enable = true;
  };

  systemd.oomd.settings.OOM = {
    DefaultMemoryPressureThreshold = "75%";
    DefaultMemoryPressureDurationSec = "10s";
  };
}
