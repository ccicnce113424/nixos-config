{
  pkgs,
  # config,
  lib,
  ...
}:
{
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
