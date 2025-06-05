{
  lib,
  self,
  inputs,
  host,
  ...
}:
{
  options.pkgsarch = lib.mkOption {
    type = lib.types.str;
    default = "pkgs";
  };

  config.nixpkgs.pkgs = import inputs.nixpkgs rec {
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
  imports = [ inputs.nixpkgs.nixosModules.readOnlyPkgs ];
}
