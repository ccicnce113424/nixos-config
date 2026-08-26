{ ... }:
{
  # environment.systemPackages = with pkgs; [
  #   (lib.hiPrio uutils-coreutils-noprefix)
  #   (lib.hiPrio uutils-findutils)
  #   (lib.hiPrio uutils-diffutils)
  #   (lib.hiPrio uutils-sed)
  #   coreutils-prefixed
  # ];

  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
    "fs.inotify.max_queued_events" = 131072;
  };

  security = {
    sudo.enable = false;
    sudo-rs.enable = true;
    rtkit.enable = true;
    polkit.enable = true;
  };

  programs.nix-ld.enable = true;

  boot = {
    supportedFilesystems = [
      "btrfs"
      "ext4"
      "f2fs"
      "xfs"
      "vfat"
      "bcachefs"
      "ntfs"
    ];
    initrd.systemd.enable = true;

    tmp = {
      useTmpfs = true;
      tmpfsHugeMemoryPages = "within_size";
    };
  };

  services.userborn.enable = true;
  services.envfs.enable = true;

  system = {
    etc.overlay.enable = true;
    nixos-init.enable = true;
  };

  systemd.oomd.settings.OOM = {
    DefaultMemoryPressureLimit = "75%";
    DefaultMemoryPressureDurationSec = "10s";
  };
}
