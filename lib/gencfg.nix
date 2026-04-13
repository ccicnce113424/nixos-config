{
  self,
  inputs,
  lib,
  nixConfig,
  withSystem,
  ...
}:
{
  options.lib'.genOSConfig = lib.mkOption {
    default =
      let
        sharedModules = [
          self.nixosModules.genpkg
          self.nixosModules.nixos-tweaks
          inputs.chaotic.nixosModules.default
          inputs.daeuniverse.nixosModules.daed
          inputs.nix-flatpak.nixosModules.nix-flatpak
          ../hosts/runtime.nix
          # inputs.solaar.nixosModules.default
        ];

        genOSConfig =
          hosts:
          builtins.mapAttrs (
            name: host:
            (withSystem host.system (
              {
                inputs',
                ...
              }:
              let
                patched = import ./patched-nixpkgs.nix {
                  inherit
                    inputs
                    lib
                    self
                    host
                    ;
                };
              in
              (import (patched.finalNixpkgs + "/nixos/lib/eval-config.nix")) {
                lib = inputs.nixpkgs.lib;
                inherit (host) system;
                modules = sharedModules ++ [ ../hosts/${name} ];
                pkgs = patched.hostPkgs;
                specialArgs = {
                  inherit
                    self
                    inputs
                    inputs'
                    nixConfig
                    ;
                  host = host // {
                    hostname = name;
                  };
                };
              }
            ))
          ) hosts;
      in
      genOSConfig;
  };
}
