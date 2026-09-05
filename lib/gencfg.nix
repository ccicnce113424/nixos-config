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
            sharedModules = [
              ../hosts/runtime.nix
              {
                nix.registry = {
                  nixpkgs-patched.to = {
                    type = "path";
                    path = patched.finalNixpkgs.outPath;
                  };
                  mypkgs.to = {
                    type = "path";
                    path = inputs.nix-packages.outPath;
                  };
                  nixos-config.to = {
                    type = "path";
                    path = ./..;
                  };
                };
                system.configurationRevision = self.rev or self.dirtyRev;
                system.nixos.label = "${inputs.nixpkgs.shortRev}.${builtins.substring 0 8 self.lastModifiedDate}.${
                  self.shortRev or self.dirtyShortRev
                }";
              }
            ];
          in
          (import (patched.finalNixpkgs.outPath + "/nixos/lib/eval-config.nix")) {
            inherit (host) system;
            modules = sharedModules ++ [
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
  };
}
