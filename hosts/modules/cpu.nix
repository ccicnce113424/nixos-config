{
  config,
  lib,
  ...
}:
let
  cfg = config.hostCfg.cpu;
in
{
  options.hostCfg.cpu = lib.mkOption {
    type = lib.types.nullOr (
      lib.types.enum [
        "intel"
        "amd"
      ]
    );
    default = null;
  };
  config = lib.mkMerge [
    {
      hardware.cpu.x86.msr.enable = true;
    }
    (lib.mkIf ("intel" == cfg) {
      boot.kernelParams = [ "intel_iommu=on" ];
      hardware.cpu.intel.updateMicrocode = true;
    })
    (lib.mkIf ("amd" == cfg) {
      hardware.cpu.amd = {
        updateMicrocode = true;
        ryzen-smu.enable = true;
      };
    })
  ];
}
