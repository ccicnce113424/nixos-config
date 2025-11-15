{
  config,
  lib,
  self,
  inputs,
  host,
  ...
}:
{
  options.pkgsArch = lib.mkOption {
    type = lib.types.str;
    default = "pkgs";
  };

  options.pkgsPatch = lib.mkOption {
    type = with lib.types; listOf (functionTo package);
    # [ (p: p.fetchpatch {...}) ]
    default = [ ];
  };

  config.nixpkgs.pkgs =
    let
      unpatchedPkgs = import inputs.nixpkgs { inherit (host) system; };
      patches = map (p: p unpatchedPkgs) config.pkgsPatch;
      patchedPkgs = unpatchedPkgs.applyPatches {
        name = "patched-nixpkgs";
        src = inputs.nixpkgs;
        inherit patches;
      };
      finalPkgs = if [ ] == patches then inputs.nixpkgs else patchedPkgs;
    in
    import finalPkgs rec {
      inherit (host) system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "olm-3.2.16"
        ];
      }
      // lib.optionalAttrs host.hostCfg.gpu.nvidia or false {
        cudaSupport = true;
      }
      // lib.optionalAttrs host.hostCfg.gpu.amdgpu or false {
        # rocmSupport = true; # Only enable if GPU supports ROCm
      };
      overlays = [
        self.overlays.default
        inputs.nur.overlays.default
        inputs.nix-packages.overlays.default
        inputs.nix-gaming.overlays.default
        (import "${inputs.chaotic}/overlays/cache-friendly.nix" {
          flakes = inputs.chaotic.inputs // {
            self = inputs.chaotic;
          };
          nixpkgsConfig = config;
        })
      ];
    };

  imports = [ inputs.nixpkgs.nixosModules.readOnlyPkgs ];
}
