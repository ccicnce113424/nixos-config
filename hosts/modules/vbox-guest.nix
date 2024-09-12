{ config, ... }:

{
  virtualisation.virtualbox.guest = {
    enable = true;
    dragAndDrop = true;
    clipboard = true;
  }
}