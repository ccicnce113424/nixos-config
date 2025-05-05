{ ... }:
{
  hardware.cpu = {
    x86.msr.enable = true;
    amd = {
      updateMicrocode = true;
      ryzen-smu.enable = true;
    };
  };
}
