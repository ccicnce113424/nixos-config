{ pkgs, ... }:
{
  services.dbus.implementation = "broker";

  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix
  ];

  # environment.memoryAllocator.provider = "mimalloc";

  security.sudo.enable = false;
  security.sudo-rs.enable = true;
  security.rtkit.enable = true;
  security.polkit.enable = true;

  programs.nix-ld.enable = true;

  boot.kernelParams = [ "iommu=pt" ];
}
