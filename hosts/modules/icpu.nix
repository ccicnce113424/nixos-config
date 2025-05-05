{ ... }:
{
  boot.kernelParams = [ "intel_iommu=on" ];
  hardware.cpu = {
    x86.msr.enable = true;
    intel.updateMicrocode = true;
  };
}
