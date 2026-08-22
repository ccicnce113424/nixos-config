{ lib, config, ... }:
let
  hosts = (import ./hosts.nix) lib;
in
{
  flake = {
    nixosConfigurations = config.lib'.genOSConfig hosts;
  };
  systems = lib.unique (lib.mapAttrsToList (_: host: host.system) hosts);
}
