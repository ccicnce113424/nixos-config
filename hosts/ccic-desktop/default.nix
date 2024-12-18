{ ... }:
{
  imports = [
    ../modules/better-pipewire.nix
    ../modules/locale-time-cn.nix
    ../modules/bluetooth.nix
    ../modules/tpm.nix
    ../modules/nvidia.nix
    #    ../modules/nouveau.nix
    ../modules/icpu.nix
    ../modules/btrfs-dedup.nix
    ./hardware-configuration.nix
  ];
}
