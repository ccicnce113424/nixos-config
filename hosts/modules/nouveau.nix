{
  pkgs,
  config,
  lib,
  ...
}:
{
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
}
