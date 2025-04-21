{ smallPkgs, ... }:
{
  boot.kernelPackages = smallPkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
