{ lib', ... }:
{
  flake = {
    nixosConfigurations = lib'.genOSConfig (import ./hosts.nix);
  };
}
