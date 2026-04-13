{ lib, config, ... }:
let
  ESP = "/efi";
in
{
  options.profile.bootSystemd = {
    enable = lib.mkEnableOption "internal boot-systemd baseline";
  };

  config = lib.mkIf config.profile.bootSystemd.enable {
    # Shared bootloader baseline for desktop/minimal profiles.
    boot.loader.timeout = 5;

    boot.loader.efi = {
      efiSysMountPoint = ESP;
      canTouchEfiVariables = true;
    };

    boot.loader.systemd-boot = {
      enable = true;
      graceful = true;
    };
  };
}
