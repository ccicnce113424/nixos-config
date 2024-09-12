{ config, pkgs, ... }:

{
  imports = [
    ./kernel.nix
    ./tweaks.nix
  ];
}