{
  pkgs,
  config,
  lib,
  ...
}:
let
  gpuCfg = {
    amdgpu = {
      services.xserver.videoDrivers = [ "amdgpu" ];
      hardware.amdgpu = {
        opencl.enable = true;
        initrd.enable = true;
      };
      environment.variables = {
        AMD_DEBUG = "useaco";
      };
      environment.systemPackages = with pkgs; [
        nvtopPackages.amd
      ];
    };
    nvidia = {
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
        "nvidia.NVreg_UsePageAttributeTable=1"
      ];

      hardware.nvidia-container-toolkit.enable = true;

      environment.systemPackages = with pkgs; [
        nvtopPackages.nvidia
        vulkan-hdr-layer-kwin6
      ];
    };
    nouveau = {
      services.xserver.videoDrivers = [ "nouveau" ];
      boot.kernelParams = [
        "nouveau.config=NvGspRm=1"
      ];
      hardware.graphics = {
        extraPackages = with pkgs; [ mesa.opencl ];
        extraPackages32 = lib.optional config.enable32Bit (with pkgs; [ mesa.opencl ]);
      };
      environment.variables = {
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
