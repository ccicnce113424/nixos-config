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
  config.patchedNixpkgs.patches = lib.mkBefore (config.lib'.pathToPatchFileset ../patches/hiprio);
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
          bootstrapPkgs = import inputs.nixpkgs { inherit (host) system; };
          hostCfg = host.hostCfg or { };
          patches = lib.fileset.toList cfg.patches;

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

          hostPkgs = import finalNixpkgs {
            inherit (host) system;
            config = {
              allowUnfree = true;
              permittedInsecurePackages = [
                "olm-3.2.16"
                "pnpm-10.29.2"
                "electron-40.10.5"
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
            ];
          };
        in
        {
          inherit finalNixpkgs hostPkgs;
        };
    };
  };
}
