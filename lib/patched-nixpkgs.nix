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
      patchesHiPrio = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = config.lib'.pathToPatchList ../patches/hiprio;
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
          patches = cfg.patchesHiPrio ++ cfg.patches;

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
              ];
            }
            // lib.optionalAttrs (hostCfg.gpu.nvidia or false) {
              cudaSupport = true;
            }
            // lib.optionalAttrs (hostCfg.gpu.amdgpu or false) {
              rocmSupport = true;
            }
            ;
            overlays = [
              self.overlays.default
              inputs.nur.overlays.default
              inputs.nix-packages.overlays.default
              inputs.nix-gaming.overlays.default
              inputs.llm-agents.overlays.shared-nixpkgs
            ];
          };
        in
        {
          inherit finalNixpkgs hostPkgs;
        };
    };
  };
}
