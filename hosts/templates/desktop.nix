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

  hardware.sane.extraBackends = with pkgs; [ hplipWithPlugin ];

  environment.systemPackages = with pkgs; [ hplipWithPlugin ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", NAME=="en*", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol g"
  '';

  services.ipp-usb.enable = true;

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.hardware.bolt.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 75;
  };
}
