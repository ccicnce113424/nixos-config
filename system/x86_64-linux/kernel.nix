{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.linuxPackages_6_10;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
