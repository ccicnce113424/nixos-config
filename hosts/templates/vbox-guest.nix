{ ... }:
{
  imports = [
    ../modules/locale-time-cn.nix
    ../modules/vbox-guest.nix
    ../modules/vm-pipewire.nix
    ../modules/printing.nix
    ./hardware-configuration.nix
  ];
}
