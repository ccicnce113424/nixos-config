{ ... }:
{
  flake.nixosModules = {
    nixos-treaks = import ./nixos-treaks.nix;
    overlay = import ./overlay.nix;
  };
}
