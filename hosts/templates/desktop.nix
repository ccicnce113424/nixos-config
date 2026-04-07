{ pkgs, lib, ... }:
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
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="0c45", ATTRS{idProduct}=="8030", TAG+="uaccess"
    SUBSYSTEM=="hidraw", ATTRS{idVendor}=="2972", ATTRS{idProduct}=="0102", TAG+="uaccess"
    SUBSYSTEM=="input", ATTRS{name}=="PC Speaker", ENV{DEVNAME}!="", TAG+="uaccess"
    ACTION=="add", SUBSYSTEM=="net", NAME=="en*", RUN+="${lib.getExe pkgs.ethtool} -s $name wol g"
  '';

  security.tpm2 = {
    enable = true;
    pkcs11.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.hardware.bolt.enable = true;

  # services.solaar.enable = true;

  zramSwap = {
    enable = true;
    memoryPercent = 75;
  };
}
