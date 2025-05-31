{ pkgs, ... }:
{
  imports = [
    ../modules/common.nix
    ../modules/cpu.nix
    ../modules/gpu.nix
  ];

  services.printing.drivers = with pkgs; [
    gutenprintBin
    hplipWithPlugin
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", NAME=="en*", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol g"
    ACTION=="add", SUBSYSTEM=="net", NAME=="wl*", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol g"
  '';

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
