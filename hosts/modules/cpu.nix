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
      pkgsArch = "pkgsx86_64_v3";
      nix.settings.system-features = [ "gccarch-x86-64-v3" ];
    };
    amd = {
      hardware.cpu.amd = {
        updateMicrocode = true;
        # TODO: re-enable this when ryzen-smu is fixed
        # ryzen-smu.enable = true;
      };
      pkgsArch = "pkgsx86_64_v3";
      nix.settings.system-features = [ "gccarch-x86-64-v3" ];
    };
  };
  cfg = config.hostCfg.cpu;
in
{
  options.hostCfg.cpu = builtins.mapAttrs (n: _: lib.mkEnableOption n) cpuCfg;
  config = lib.mkMerge (lib.mapAttrsToList (type: c: (lib.mkIf cfg.${type} c)) cpuCfg);
}
