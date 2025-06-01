{ pkgs, lib, ... }:
{
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
