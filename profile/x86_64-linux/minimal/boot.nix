{ ... }:
let
  ESP = "/efi";
in
{
  # Settings for bootloader
  boot.loader.timeout = 5;

  boot.loader.efi = {
    efiSysMountPoint = ESP;
    canTouchEfiVariables = true;
  };

  boot.loader.systemd-boot = {
    enable = true;
    graceful = true;
  };

  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
}
