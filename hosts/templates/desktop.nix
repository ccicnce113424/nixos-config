{ pkgs, ... }:
{
  imports = [
    ../modules/desktop.nix
    ../modules/cpu.nix
    ../modules/gpu.nix
    ../modules/locale.nix
  ];

  services.printing.drivers = with pkgs; [
    gutenprintBin
    hplipWithPlugin
  ];

  hardware.sane.extraBackends = with pkgs; [ hplipWithPlugin ];

  environment.systemPackages = with pkgs; [
    gutenprintBin
    hplipWithPlugin
  ];

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="net", NAME=="en*", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol g"
  '';

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.hardware.bolt.enable = true;

  services.solaar.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 75;
  };
}
