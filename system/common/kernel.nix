{ pkgs, inputs, ... }:
{
  boot.kernelPackages = inputs.nixpkgs-small.legacyPackages.${pkgs.system}.linuxPackages_latest;
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
  };
}
