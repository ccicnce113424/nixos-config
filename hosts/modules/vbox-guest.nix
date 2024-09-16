{ config, ... }:

{
  # imports = [./vm-audio.nix];
  virtualisation.virtualbox.guest = {
    enable = true;
    dragAndDrop = true;
    clipboard = true;
  };
}