{
  config,
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
  # Add patches which modify nixpkgs modules here to prevent infinite recursion
  modulePatches = map unpatchedPkgs.fetchpatch [
    {
      url = "https://github.com/NixOS/nixpkgs/pull/482959.patch";
      hash = "sha256-LRkAm4QRQq/guCFE7l89tCwAG7Pjmv2D2cxM4pvynis=";
    }
    {
      url = "https://github.com/NixOS/nixpkgs/pull/391574.patch";
      hash = "sha256-VPJ84atxP4CgkkzGkNmmWI4sDxwvjX5H/+YRi3/uXqk=";
    }
  ];
  replaceModules = [
    # 482959
    "services/networking/ntp/chrony.nix"
    # 391574
    "services/ttys/getty.nix"
    "services/ttys/kmscon.nix"
  ];
  modulePatchedPkgs' = applyPatches {
    name = "source";
    src = inputs.nixpkgs;
    patches = modulePatches;
  };
  modulePatchedPkgs = if [ ] == modulePatches then inputs.nixpkgs else modulePatchedPkgs';
  # Apply package patches
  patches = map (p: p unpatchedPkgs) config.pkgsPatch;
  patchedPkgs = applyPatches {
    name = "source";
    src = modulePatchedPkgs;
    inherit patches;
  };
  finalPkgs = if [ ] == patches then modulePatchedPkgs else patchedPkgs;
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
          "olm-3.2.16"
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
        (import "${inputs.chaotic}/overlays/cache-friendly.nix" {
          flakes = inputs.chaotic.inputs // {
            self = inputs.chaotic;
          };
          nixpkgsConfig = config;
        })
      ];
    };

    # Prevent GC
    nix.registry = {
      nixpkgs-module-patched.to = {
        type = "path";
        path = modulePatchedPkgs.outPath;
      };
      nixpkgs-patched.to = {
        type = "path";
        path = finalPkgs.outPath;
      };
    };
  };

  imports = [
    inputs.nixpkgs.nixosModules.readOnlyPkgs
  ]
  ++ (map (path: modulePatchedPkgs.outPath + "/nixos/modules/" + path) replaceModules);

  disabledModules = replaceModules;
}
