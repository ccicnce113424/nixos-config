{ ... }:
{
  services.dbus.implementation = "broker";
  services.scx-loader = {
    enable = true;
    defaultSched = "scx_lavd";
    schedsCfg."scx_lavd".auto = [ "--autopower" ];
  };

  # environment.systemPackages = with pkgs; [
  #   (lib.hiPrio uutils-coreutils-noprefix)
  #   (lib.hiPrio uutils-findutils)
  #   (lib.hiPrio uutils-diffutils)
  #   (lib.hiPrio uutils-sed)
  #   coreutils-prefixed
  # ];

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
      "ntfsplus"
      "bcachefs"
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
