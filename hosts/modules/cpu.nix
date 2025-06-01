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
    };
    amd = {
      hardware.cpu.amd = {
        updateMicrocode = true;

        # build failed with cachyos-lto
        # ryzen-smu.enable = true;
      };
    };
  };
  cfg = config.hostCfg.cpu;
in
{
  options.hostCfg.cpu = builtins.mapAttrs (n: _: lib.mkEnableOption n) cpuCfg;
  config = lib.mkMerge (lib.mapAttrsToList (type: c: (lib.mkIf cfg.${type} c)) cpuCfg);
}
