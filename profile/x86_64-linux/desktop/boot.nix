{
  pkgs,
  lib,
  config,
  ...
}:
let
  ESP = config.boot.loader.efi.efiSysMountPoint;
  XBOOTLDR = "/boot";
in
{
  imports = [
    ../../common/boot-systemd.nix
  ];

  config = lib.mkIf (config.runtime.profile == "desktop") {
    profile.bootSystemd = {
      enable = true;
    };

    # Settings for bootloader
    boot.loader.systemd-boot = {
      # Installation
      xbootldrMountPoint = XBOOTLDR;

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
        find = lib.getExe' pkgs.findutils "find";
      in
      lib.mkAfter ''
        # Secure Boot
        if [ ! -d "/var/lib/sbctl/keys/" ]; then
          ${sbctl} create-keys
          ${sbctl} enroll-keys -m
          echo "You need to enroll the keys into your firmware manually if you are not in setup mode of Secure Boot." 1>&2
        fi
        ${find} "${ESP}/EFI/systemd" -type f -name "*.efi" -exec ${sbctl} sign {} \;
        ${find} "${XBOOTLDR}" -type f \( -name "*.efi" -o -name "*linux*" \) \
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
  };
}
