{ ... }:

{
  # imports = [./vm-audio.nix];
  services.xserver.videoDrivers = [ "vmware" ];
  virtualisation.vmware.guest.enable = true;
}
