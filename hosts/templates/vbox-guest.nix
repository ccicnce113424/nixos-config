{ ... }:
{
  imports = [
    ../modules/locale-time-cn.nix
    ../modules/vbox-guest.nix
    ../modules/vm-pipewire.nix
    ./hardware-configuration.nix
  ];
}
