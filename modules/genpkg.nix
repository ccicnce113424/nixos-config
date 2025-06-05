{
  config,
  lib,
  self,
  inputs,
  host,
  ...
}:
let
  pkgs = import inputs.nixpkgs rec {
    system = host.system;
    config =
      {
        allowUnfree = true;
        permittedInsecurePackages = [
          "olm-3.2.16"
        ];
      }
      // lib.optionalAttrs host.hostCfg.gpu.nvidia or false {
        cudaSupport = true;
      }
      // lib.optionalAttrs host.hostCfg.gpu.amdgpu or false {
        rocmSupport = true;
      };
    overlays = [
      inputs.nur.overlays.default
      (import "${inputs.chaotic}/overlays/cache-friendly.nix" {
        flakes = inputs.chaotic.inputs // {
          self = inputs.chaotic;
        };
        nixpkgsConfig = config;
      })
      self.overlays.default
    ];
  };
  pkgsWithOptimization = pkgs."pkgs${config.microarch}";
in
{
  options.microarch = lib.mkOption {
    type = lib.types.str;
    default = "";
  };
  config = {
    nixpkgs.pkgs = pkgs;
    _module.args.pkgs' = pkgsWithOptimization;
    home-manager.extraSpecialArgs.pkgs' = pkgsWithOptimization;
  };
}
