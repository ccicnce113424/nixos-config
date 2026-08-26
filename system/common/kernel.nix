{
  pkgs,
  # config,
  lib,
  ...
}:
{
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
}
