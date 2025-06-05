{ ... }:
{
  flake.nixosModules = {
    nixos-treaks = import ./nixos-treaks.nix;
  };
}
