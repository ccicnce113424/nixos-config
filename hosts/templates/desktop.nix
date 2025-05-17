{ ... }:
{
  imports = [
    ../modules/common.nix
    ../modules/cpu.nix
    ../modules/gpu.nix
  ];

  services.printing = {
    enable = true;
    cups-pdf = {
      enable = true;
      instances.PDF.settings.Out = "\${HOME}/cups-pdf";
    };
  };

  security.tpm2 = {
    enable = true;
  };

  hardware.bluetooth.enable = true;
  services.hardware.bolt.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 75;
  };
}
