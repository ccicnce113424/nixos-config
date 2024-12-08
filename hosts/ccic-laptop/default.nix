{ ... }:
{
  imports = [
    ../modules/better-pipewire.nix
    ../modules/locale-time-cn.nix
    ../modules/printing.nix
    ../modules/bluetooth.nix
    ../modules/tpm.nix
    ../modules/amdcl.nix
    ../modules/btrfs-dedup.nix
    ./hardware-configuration.nix
  ];
}
