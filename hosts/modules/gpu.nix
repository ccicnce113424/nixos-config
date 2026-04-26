{
  pkgs,
  config,
  lib,
  ...
}:
let
  common = {
    services.lact.enable = true;
  };
  gpuCfg = {
    amdgpu = lib.recursiveUpdate common {
      services.xserver.videoDrivers = [ "amdgpu" ];
      hardware.amdgpu = {
        opencl.enable = true;
      };
      environment.sessionVariables = {
        AMD_DEBUG = "useaco";
      };
      environment.systemPackages = with pkgs; [
        nvtopPackages.amd
      ];
    };
    nvidia = lib.recursiveUpdate common {
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        open = true;
        gsp.enable = true;
        modesetting.enable = true;
        nvidiaSettings = true;
        videoAcceleration = true;
        powerManagement.enable = true;
        branch = "bleeding_edge";
        moduleParams = {
          nvidia = {
            NVreg_RegistryDwords = "EnableBrightnessControl=1";
            NVreg_EnablePCIERelaxedOrderingMode = 1;
            NVreg_EnableStreamMemOPs = 1;
            NVreg_UsePageAttributeTable = 1;
          };
        };
      };

      hardware.nvidia-container-toolkit.enable = true;

      environment.systemPackages = with pkgs; [
        nvtopPackages.nvidia
      ];

      environment.sessionVariables = {
        CUDA_DISABLE_PERF_BOOST = 1;
      };
    };
    nouveau = lib.recursiveUpdate common {
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
    };
  };
  cfg = config.hostCfg.gpu;
in
{
  options.hostCfg.gpu = builtins.mapAttrs (n: _: lib.mkEnableOption n) gpuCfg;
  config = lib.mkMerge (lib.mapAttrsToList (type: c: (lib.mkIf cfg.${type} c)) gpuCfg);
}
