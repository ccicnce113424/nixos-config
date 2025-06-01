{ pkgs, lib, ... }:
{
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos-lto;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
