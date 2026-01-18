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
    font = "${pkgs.maple-mono.truetype}/share/fonts/truetype/MapleMono-Regular.ttf";
  };

  # Silent boot
  boot.kernelParams = [
    "quiet"
    "udev.log_level=3"
    "systemd.show_status=auto"
  ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
}
