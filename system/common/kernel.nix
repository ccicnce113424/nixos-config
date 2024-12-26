{ pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
