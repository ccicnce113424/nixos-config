{
  pkgs,
  # config,
  lib,
  ...
}:
{
  # boot.kernelPackages = lib.mkForce pkgs.${config.pkgsArch}.linuxPackages_cachyos-lto;
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_cachyos-gcc;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
