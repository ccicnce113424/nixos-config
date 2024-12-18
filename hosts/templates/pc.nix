{ ... }:
{
  imports = [
    ../modules/better-pipewire.nix
    ../modules/locale-time-cn.nix
    ../modules/bluetooth.nix
    ../modules/tpm.nix
    ./hardware-configuration.nix
  ];
}
