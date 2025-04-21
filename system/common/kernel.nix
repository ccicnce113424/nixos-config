{ config, ... }:
{
  boot.kernelPackages = config.smallPkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
