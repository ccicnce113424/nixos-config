{
  config,
  inputs,
  lib,
  self,
  ...
}:
let
  cfg = config.patchedNixpkgs;
in
{
  options = {
    patchedNixpkgs = {
      patchesHighPriority = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = map builtins.fetchurl [
          # we're not using this package, but we need this to avoid a hunk failure
          # remove after the next channel update
          {
            url = "https://github.com/ccicnce113424/nixpkgs/commit/eda0c70a7e0ccc8a48ae23361571431af85b7f5a.patch";
            sha256 = "sha256-5BAN7mD5zEo/UGbmofgDYk2f8+uV9Y0G/n92nwkaxu8=";
          }
        ];
      };
      patches = lib.mkOption {
        type = lib.types.listOf lib.types.path;
      };
    };
    lib'.patchedNixpkgs = lib.mkOption {
      default =
        host:
        let
          bootstrapPkgs = import inputs.nixpkgs { inherit (host) system; };
          hostCfg = host.hostCfg or { };
          patches = cfg.patchesHighPriority ++ cfg.patches;

          patchedNixpkgs =
            (bootstrapPkgs.applyPatches {
              name = "source";
              src = inputs.nixpkgs;
              inherit patches;
            }).overrideAttrs
              (old: {
                nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ bootstrapPkgs.fuc ];
                installPhase = "cpz ./ $out";
              });

          finalNixpkgs = if [ ] == patches then inputs.nixpkgs else patchedNixpkgs;

          hostPkgs = import finalNixpkgs rec {
            inherit (host) system;
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                # "electron-38.8.4"
              ];
            }
            // lib.optionalAttrs (hostCfg.gpu.nvidia or false) {
              cudaSupport = true;
            }
            // lib.optionalAttrs (hostCfg.gpu.amdgpu or false) {
              rocmSupport = true;
            };
            overlays = [
              self.overlays.default
              inputs.nur.overlays.default
              inputs.nix-packages.overlays.default
              inputs.nix-gaming.overlays.default
              (import (inputs.chaotic.outPath + "/overlays/cache-friendly.nix") {
                flakes = inputs.chaotic.inputs // {
                  self = inputs.chaotic;
                };
                nixpkgsConfig = config;
              })
            ];
          };
        in
        {
          inherit finalNixpkgs hostPkgs;
        };
    };
  };
}
