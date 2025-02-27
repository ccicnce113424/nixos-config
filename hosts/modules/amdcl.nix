{ pkgs, ... }:
{
  hardware.graphics = {
    extraPackages = with pkgs; [
      mesa.opencl
      # rocmPackages.clr.icd
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa.opencl
    ];
  };
  environment.sessionVariables = {
    RUSTICL_ENABLE = "radeonsi";
    RUSTICL_FEATURES = "fp16,fp64";
  };
}
