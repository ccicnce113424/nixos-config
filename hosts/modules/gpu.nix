{
  pkgs,
  config,
  lib,
  ...
}:
let
  gpu = config.hostCfg.gpu;
in
{
  options.hostCfg.gpu = lib.genAttrs [ "amdgpu" "nvidia" "nouveau" ] (
    _:
    lib.mkOption {
      type = lib.types.bool;
      default = false;
    }
  );
  config = lib.mkMerge [
    (lib.mkIf gpu.amdgpu {
      services.xserver.videoDrivers = [ "amdgpu" ];
      hardware.amdgpu = {
        opencl.enable = true;
      };
      environment.variables = {
        AMD_DEBUG = "useaco";
      };
      nixpkgs.config.rocmSupport = true;
    })

    (lib.mkIf gpu.nvidia {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        open = true;
        gsp.enable = true;
        modesetting.enable = true;
        nvidiaSettings = true;
        videoAcceleration = true;
        powerManagement.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };

      boot.kernelParams = [
        "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=1"
        "nvidia.NVreg_EnablePCIERelaxedOrderingMode=1"
        "nvidia.NVreg_EnableStreamMemOPs=1"
      ];

      hardware.nvidia-container-toolkit.enable = true;

      nixpkgs.config.cudaSupport = true;
    })

    (lib.mkIf gpu.nouveau {
      services.xserver.videoDrivers = [ "nouveau" ];
      boot.kernelParams = [
        "nouveau.config=NvGspRm=1"
      ];
      hardware.graphics = {
        extraPackages = with pkgs; [ mesa.opencl ];
        extraPackages32 = lib.optional config.enable32Bit (with pkgs; [ mesa.opencl ]);
      };
      environment.sessionVariables = {
        RUSTICL_ENABLE = "nouveau";
        RUSTICL_FEATURES = "fp16,fp64";
      };
    })
  ];
}
