{ config, pkgs, ... }:

{
  services.dbus.implementation = "broker";

  environment.systemPackages = with pkgs; [
    uutils-coreutils-noprefix
  ];

  environment.memoryAllocator.provider = "jemalloc";

  security.sudo.enable = false;
  security.sudo-rs.enable = true;
  security.rtkit.enable = true;
}