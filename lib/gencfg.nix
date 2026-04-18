{
  self,
  inputs,
  lib,
  config,
  nixConfig,
  withSystem,
  ...
}:
{
  options.lib'.genOSConfig = lib.mkOption {
    default =
      let
        sharedModules = [
          self.nixosModules.nixos-tweaks
          inputs.chaotic.nixosModules.default
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
                patched = config.lib'.patchedNixpkgs host;
                patchedRegistryModule = {
                  nix.registry = {
                    nixpkgs-patched.to = {
                      type = "path";
                      path = patched.finalNixpkgs.outPath;
                    };
                  };
                };
              in
              (import (patched.finalNixpkgs.outPath + "/nixos/lib/eval-config.nix")) {
                lib = inputs.nixpkgs.lib;
                inherit (host) system;
                modules = sharedModules ++ [
                  patchedRegistryModule
                  ../hosts/${name}
                ];
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
