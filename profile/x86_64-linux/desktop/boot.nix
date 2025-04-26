{ pkgs, lib, ... }:
let
  ESP = "/efi";
  XBOOTLDR = "/boot";
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
    xbootldrMountPoint = XBOOTLDR;
    graceful = true;
    memtest86.enable = true;
    edk2-uefi-shell.enable = true;
    netbootxyz.enable = true;
  };

  environment.systemPackages = with pkgs; [
    sbctl
  ];

  # Secure Boot
  boot.loader.systemd-boot.extraInstallCommands = lib.mkAfter ''
    ${pkgs.sbctl}/bin/sbctl create-keys
    echo "Remember to enroll the keys into your firmware!"
    ${pkgs.findutils}/bin/find "${ESP}/EFI/systemd" -type f -name "*.efi" -exec ${pkgs.sbctl}/bin/sbctl sign {} \;
    ${pkgs.findutils}/bin/find "${XBOOTLDR}" -type f \( -name "*.efi" -o -name "*linux*" \) ! -name "*init*" ! -wholename "*.extra-files/*" -exec ${pkgs.sbctl}/bin/sbctl sign {} \;
  '';

  # Splash screen
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  # Silent boot
  boot.kernelParams = [
    "quiet"
    "boot.shell_on_fail"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
}
