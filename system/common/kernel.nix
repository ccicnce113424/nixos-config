{
  pkgs,
  # config,
  lib,
  ...
}:
{
  # boot.kernelPackages = lib.mkForce pkgs.${config.pkgsarch}.linuxPackages_cachyos-lto;
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos-lto;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
