{ config, lib, ... }:
{
  boot.kernelPackages = lib.mkForce config.smallPkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
