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
    # Installation
    xbootldrMountPoint = XBOOTLDR;
    graceful = true;

    # Behavior
    consoleMode = "auto";
    rebootForBitlocker = true;

    # Tools
    memtest86.enable = true;
    edk2-uefi-shell.enable = true;
    netbootxyz.enable = true;
  };

  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot.loader.systemd-boot.extraInstallCommands = lib.mkAfter ''
    # Secure Boot
    ${pkgs.sbctl}/bin/sbctl create-keys
    echo "Remember to enroll the keys into your firmware!" 1>&2
    ${pkgs.findutils}/bin/find "${ESP}/EFI/systemd" -type f -name "*.efi" -exec ${pkgs.sbctl}/bin/sbctl sign {} \;
    ${pkgs.findutils}/bin/find "${XBOOTLDR}" -type f \( -name "*.efi" -o -name "*linux*" \) ! -name "*init*" ! -wholename "*.extra-files/*" -exec ${pkgs.sbctl}/bin/sbctl sign {} \;

    echo "Removing systemd-boot related efi variables." 1>&2
    bootctl set-default ""
    bootctl set-timeout ""
    chattr -i /sys/firmware/efi/efivars/LoaderConfigConsoleMode-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f 2>/dev/null || true
    rm -f /sys/firmware/efi/efivars/LoaderConfigConsoleMode-4a67b082-0a4c-41cf-b6c7-440b29bb8c4f 2>/dev/null || true
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
