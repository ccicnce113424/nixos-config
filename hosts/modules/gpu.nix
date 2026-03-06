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
        # initrd.enable = true;
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
      # boot.initrd.kernelModules = [
      #   "nvidia"
      #   "nvidia_modeset"
      #   "nvidia_drm"
      #   "nvidia_uvm"
      # ];

      hardware.nvidia-container-toolkit.enable = true;

      environment.systemPackages = with pkgs; [
        nvtopPackages.nvidia
      ];

      # custom driver package
      # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver rec {
      #   version = "580.94.18";
      #   persistencedVersion = "580.95.05";
      #   settingsVersion = "580.95.05";
      #   sha256_64bit = "sha256-FcbmHcwyrUt+1k31UgmX2WZNLLJ4BB5L3pbYUMrwtYo=";
      #   openSha256 = "sha256-1Zt8DY2P43L+k2u90rfGCK1dFLnlnaASqoe+qyVNw7k=";
      #   settingsSha256 = "sha256-F2wmUEaRrpR1Vz0TQSwVK4Fv13f3J9NJLtBe4UP2f14=";
      #   persistencedSha256 = "sha256-QCwxXQfG/Pa7jSTBB0xD3lsIofcerAWWAHKvWjWGQtg=";
      #   url = "https://developer.nvidia.com/downloads/vulkan-beta-${lib.concatStrings (lib.splitVersion version)}-linux";
      #   patchesOpen = [
      #     (pkgs.fetchpatch {
      #       url = "https://github.com/CachyOS/CachyOS-PKGBUILDS/raw/d5629d64ac1f9e298c503e407225b528760ffd37/nvidia/nvidia-580xx/nvidia-580xx-utils/kernel-6.19.patch";
      #       hash = "sha256-XlRDAC780oWvD3uY9pgqG8YWvZFVGhc4f18f5ZDFM1g=";
      #     })
      #   ];
      # };
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
