{ ... }:
{
  imports = [
    ../modules/better-pipewire.nix
    ../modules/locale-time-cn.nix
    ../modules/printing.nix
    ../modules/bluetooth.nix
    ../modules/tpm.nix
    ../modules/nvidia.nix
#    ../modules/nouveau.nix
    ../modules/icpu.nix
    ./hardware-configuration.nix
  ];
}
