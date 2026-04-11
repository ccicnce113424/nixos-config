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
  patches = map builtins.fetchurl [
    # nixos/nvidia, linuxPackages.nvidia-x11: split proprietary kernel modules, use source-built ICDs, write params via modprobe
    {
      url = "https://github.com/NixOS/nixpkgs/pull/498612.patch";
      sha256 = "sha256-CWXJFZXLfJZXtFVYm/wSwRU7asJbJ65kY61n6TceYwY=";
    }
    # flutterPackages: fix hostPlatform rename evaluation warning
    # merged, remove after next channel update
    {
      url = "https://github.com/NixOS/nixpkgs/pull/507484.patch";
      sha256 = "sha256-8sJymfgEVzuoGXQRuXPvX5bdYu3ee3SPKuimsYQXFR4=";
    }
    # treewide: fix icon by adding 512x512 image
    {
      url = "https://github.com/NixOS/nixpkgs/pull/508397.patch";
      sha256 = "sha256-MspBLvyZGycLN2bKBlEPoJfOwZInqQhWA5sWUsSaapo=";
    }
  ];
  replaceModules = [
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

  config = {
    nixpkgs.pkgs = import finalPkgs rec {
      inherit (host) system;
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          # "electron-38.8.4"
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
