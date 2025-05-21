{ lib, lib', ... }:
let
  hosts = import ./hosts.nix;
in
{
  flake = {
    nixosConfigurations = lib'.genOSConfig hosts;
  };
  systems = lib.unique (lib.mapAttrsToList (_: host: host.system) hosts);
}
