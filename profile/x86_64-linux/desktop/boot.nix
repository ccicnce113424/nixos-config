{ config, pkgs, ... }:
let
  ESP = "/efi";
  XBOOTLDR = "/boot";
  KEYS_DIR = "/var/lib/sbctl/keys";
  DB_DIR = "${KEYS_DIR}/db";
  KEK_DIR = "${KEYS_DIR}/KEK";
  PK_DIR = "${KEYS_DIR}/PK";
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
  };

  environment.systemPackages = with pkgs; [
    sbctl
  ];

  # Secure Boot
  system.activationScripts.secureboot = ''
    is_empty_or_missing() {
        local dir="$1"
        [[ ! -d "$dir" || -z "$(ls -A "$dir" 2>/dev/null)" ]]
    }

    if is_empty_or_missing "${DB_DIR}" || is_empty_or_missing "${KEK_DIR}" || is_empty_or_missing "${PK_DIR}"; then
        echo "No keys found, creating new keys..."
        ${pkgs.sbctl}/bin/sbctl create-keys
    else
        echo "Using existing keys."
    fi
    echo "Remember to enroll the keys into your firmware!"
    
    find "${ESP}/EFI/systemd" -type f -name "*.efi" -exec ${pkgs.sbctl}/bin/sbctl sign {} \;
    find "${XBOOTLDR}" -type f \( -name "*.efi" -o -name "*linux*" \) -exec ${pkgs.sbctl}/bin/sbctl sign {} \;
  '';

  # Splash screen
  boot.plymouth = {
    enable = true;
    theme = "bgrt";
  };

  # Silent boot
  boot.kernelParams = [
    "quiet"
    "splash"
    "boot.shell_on_fail"
    "loglevel=3"
    "rd.systemd.show_status=false"
    "rd.udev.log_level=3"
    "udev.log_priority=3"
  ];
  boot.consoleLogLevel = 3;
  boot.initrd.verbose = false;
}
