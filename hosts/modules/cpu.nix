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
        ryzen-smu.enable = true;
      };
    };
  };
  cfg = config.hostCfg.cpu;
in
{
  options.hostCfg.cpu = builtins.mapAttrs (
    _: _:
    lib.mkOption {
      type = lib.types.bool;
      default = false;
    }
  ) cpuCfg;
  config = lib.mkMerge (lib.mapAttrsToList (type: c: (lib.mkIf cfg.${type} c)) cpuCfg);
}
