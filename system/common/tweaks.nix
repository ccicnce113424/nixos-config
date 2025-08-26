{ pkgs, ... }:
{
  services.dbus.implementation = "broker";
  services.scx.enable = true;
  pkgsPatch = [
    (
      p:
      p.fetchpatch {
        name = "fix-scx.patch";
        url = "https://github.com/NixOS/nixpkgs/commit/15f47f87239d31a84da0e148042e283de6a43f65.patch";
        hash = "sha256-qMSLkuDQvAFSBxW4E1hRDWEmcXdbpI+b+xpQ/mbhwEw=";
      }
    )
  ];

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
