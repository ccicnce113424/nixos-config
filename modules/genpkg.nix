{
  lib,
  self,
  inputs,
  host,
  ...
}:
let
  unpatchedPkgs = import inputs.nixpkgs { inherit (host) system; };
  # use fuc for fast copying
  applyPatches =
    args:
    (unpatchedPkgs.applyPatches args).overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ unpatchedPkgs.fuc ];
      installPhase = "cpz ./ $out";
    });
  # patches
  patches = map unpatchedPkgs.fetchpatch2 [
    {
      url = "https://github.com/NixOS/nixpkgs/pull/489469.diff?full_index=1";
      hash = "sha256-L0jItNvvUbyE8nwPsjSZ93djYDifWoTWB5uO6YJ89ag=";
    }
    {
      url = "https://github.com/NixOS/nixpkgs/pull/498612.diff?full_index=1";
      hash = "sha256-Cr0lcnDEujl6fqLh6imQYXSsUOcW/zVhdKh3UuArW38=";
    }
  ];
  replaceModules = [
    # 489469
    "services/ttys/getty.nix"
    "services/ttys/kmscon.nix"
    # 498612
    "hardware/video/nvidia.nix"
  ];
  patchedPkgs = applyPatches {
    name = "source";
    src = inputs.nixpkgs;
    inherit patches;
  };
  finalPkgs = if [ ] == patches then inputs.nixpkgs else patchedPkgs;
in
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

  config = {
    nixpkgs.pkgs = import finalPkgs rec {
      inherit (host) system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          # "olm-3.2.16"
        ];
      }
      // lib.optionalAttrs host.hostCfg.gpu.nvidia or false {
        cudaSupport = true;
      }
      // lib.optionalAttrs host.hostCfg.gpu.amdgpu or false {
        rocmSupport = true; # Only enable if GPU supports ROCm
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

    # Prevent GC
    nix.registry = {
      nixpkgs-patched.to = {
        type = "path";
        path = finalPkgs.outPath;
      };
    };
  };

  imports = [
    inputs.nixpkgs.nixosModules.readOnlyPkgs
  ]
  ++ (map (path: finalPkgs.outPath + "/nixos/modules/" + path) replaceModules);

  disabledModules = replaceModules;
}
