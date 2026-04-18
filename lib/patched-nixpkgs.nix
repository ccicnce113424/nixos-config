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
      sha256 = "sha256-Xc7ZC/+sHEX6iG/Qv+TgzbjMZTK3qyxMDAZrkNxzSl8=";
    }
    # we're not using this package, but we need this to avoid a hunk failure
    # remove after the next channel update
    {
      url = "https://github.com/ccicnce113424/nixpkgs/commit/eda0c70a7e0ccc8a48ae23361571431af85b7f5a.patch";
      sha256 = "sha256-5BAN7mD5zEo/UGbmofgDYk2f8+uV9Y0G/n92nwkaxu8=";
    }
    # treewide: fix icon by moving to valid path
    # merged, remove after the next channel update
    {
      url = "https://github.com/NixOS/nixpkgs/pull/510472.patch";
      sha256 = "sha256-Arjxr4WKlpSvgZO8mif89k28unYXG0SITzrhRnAwyEw=";
    }
    # kmscon: 9.3.3 -> 9.3.4-unstable-2026-04-13, nixos/kmscon: make agetty optional
    # test upcoming package and module updates
    {
      url = "https://github.com/NixOS/nixpkgs/pull/508807.patch";
      sha256 = "sha256-kZLPubV9gtMD1E9df0J6CsuUmRDStSM1Nil6dB2qhCc=";
    }
    # daed: 1.0.0 -> 1.27.0, add nixos module and maintainer
    {
      url = "https://github.com/NixOS/nixpkgs/pull/510895.patch";
      sha256 = "sha256-1Dtc0T27jbcfNHjAh/WO7e1wXxwQJsRM3AxsAM1tjBo=";
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
