{
  config,
  lib,
  ...
}:
let
  cpuCfg = {
    intel = {
      boot.kernelParams = [ "intel_iommu=on" ];
      hardware.cpu.intel.updateMicrocode = true;
      microarch = lib.mkForce "x86_64_v3";
    };
    amd = {
      hardware.cpu.amd = {
        updateMicrocode = true;
        # build failed with cachyos-lto
        # ryzen-smu.enable = true;
      };
      microarch = lib.mkDefault "x86_64_v4";
    };
  };
  cfg = config.hostCfg.cpu;
in
{
  options.hostCfg.cpu = builtins.mapAttrs (n: _: lib.mkEnableOption n) cpuCfg;
  config = lib.mkMerge (lib.mapAttrsToList (type: c: (lib.mkIf cfg.${type} c)) cpuCfg);
}
