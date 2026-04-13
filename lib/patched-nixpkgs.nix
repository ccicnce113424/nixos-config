{
  inputs,
  lib,
  self,
  host,
}:
let
  bootstrapPkgs = import inputs.nixpkgs { inherit (host) system; };
  hostCfg = host.hostCfg or { };

  patches = map builtins.fetchurl [
    # nixos/nvidia, linuxPackages.nvidia-x11: split proprietary kernel modules, use source-built ICDs, write params via modprobe
    {
      url = "https://github.com/NixOS/nixpkgs/pull/498612.patch";
      sha256 = "sha256-gr9YNei4NshAx/CRQE3dgK5X+DGO1O07lE9w1qfzzic=";
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
    # hmcl: add libxkbcommon and jdk 25, don't use system glfw by default
    {
      url = "https://github.com/NixOS/nixpkgs/pull/508813.patch";
      sha256 = "sha256-ryziHMsFYzmrMfdyXk0TM/9TFwJ5Xn9RqDoFjV+3dE4=";
    }
  ];

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
}
