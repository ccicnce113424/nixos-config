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

  boot.loader.systemd-boot.extraInstallCommands =
    let
      sbctl = lib.getExe pkgs.sbctl;
      findutils = lib.getExe pkgs.findutils;
    in
    lib.mkAfter ''
      # Secure Boot
      ${sbctl} create-keys
      echo "Remember to enroll the keys into your firmware!" 1>&2
      ${findutils} -name "*.efi" -exec ${sbctl} sign {} \;
      ${findutils}/bin/find "${XBOOTLDR}" \
        -type f \( -name "*.efi" -o -name "*linux*" \) \
        ! -name "*init*" ! -wholename "*.extra-files/*" \
        -exec ${sbctl} sign {} \;

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
