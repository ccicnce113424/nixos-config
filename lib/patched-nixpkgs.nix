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
  config = {
    patchedNixpkgs.patches = lib.mkBefore (config.lib'.pathToPatchFileset ../patches/hiprio);
    perSystem =
      { system, ... }:
      {
        packages.patchedNixpkgs = (config.lib'.patchedNixpkgs { forceSystem = system; }).finalNixpkgs;
      };
  };
  options = {
    patchedNixpkgs = {
      patches = lib.mkOption {
        type = lib.types.fileset;
      };
      pins = lib.mkOption {
        type = lib.types.attrs;
        default = { };
      };
      overridePackagesFromMv = lib.mkOption {
        type = lib.types.functionTo lib.types.attrs;
        default = _mv: { };
      };
    };
    lib'.patchedNixpkgs = lib.mkOption {
      default =
        host:
        let
          bootstrapPkgs = import inputs.nixpkgs {
            system = host.forceSystem or builtins.currentSystem or host.system;
          };
          hostCfg = host.hostCfg or { };
          patches = lib.fileset.toList cfg.patches;

          # applyPatches = bootstrapPkgs.callPackage ./apply-patches-cow.nix { };
          applyPatches =
            p:
            (bootstrapPkgs.applyPatches p).overrideAttrs (prev: {
              nativeBuildInputs = prev.nativeBuildInputs or [ ] ++ [ bootstrapPkgs.fuc ];
              installPhase = "cpz ./ $out";
              __structuredAttrs = true;
              unsafeDiscardReferences.out = true;
            });

          patchedNixpkgs = applyPatches {
            name = "source";
            src = inputs.nixpkgs;
            inherit patches;
          };

          finalNixpkgs = if [ ] == patches then inputs.nixpkgs else patchedNixpkgs;

          hostPkgs = import finalNixpkgs {
            inherit (host) system;
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
              ];
            }
            // lib.optionalAttrs (hostCfg.gpu.nvidia or false) {
              cudaSupport = true;
            }
            // lib.optionalAttrs (hostCfg.gpu.amdgpu or false) {
              rocmSupport = true;
            };
            overlays = [
              (inputs.multiverse.lib.pinOverlay {
                inherit (cfg) pins;
                config.allowUnfree = true;
              })
              (_: _: {
                mv = inputs.multiverse.lib.mkMultiverse {
                  inherit (host) system;
                  config.allowUnfree = true;
                  overlays = [
                    # whatever overlays you want to apply to every revision
                  ];
                };
              })
              (final: _: cfg.overridePackagesFromMv final.mv)
              self.overlays.default
              inputs.nur.overlays.default
              inputs.nix-packages.overlays.default
              inputs.nix-gaming.overlays.default
              inputs.llm-agents.overlays.shared-nixpkgs
              inputs.gaze.overlays.default
              inputs.multiverse.overlays.default
            ];
          };
        in
        {
          inherit finalNixpkgs hostPkgs;
        };
    };
  };
}
