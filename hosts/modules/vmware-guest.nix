{ ... }:

{
  imports = [ ./vm-pipewire.nix ];
  services.xserver.videoDrivers = [ "vmware" ];
  virtualisation.vmware.guest.enable = true;
}
