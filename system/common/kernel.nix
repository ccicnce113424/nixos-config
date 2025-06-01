{ pkgs, lib, ... }:
{
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_15;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
