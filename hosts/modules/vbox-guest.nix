{ ... }:
{
  imports = [ ./vm-pipewire.nix ];
  virtualisation.virtualbox.guest = {
    enable = true;
    dragAndDrop = true;
    clipboard = true;
  };
}
