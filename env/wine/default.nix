{ pkgs, ... }:
{
  boot.kernelModules = [ "ntsync" ];
  services.udev.extraRules = ''KERNEL=="ntsync", MODE="0644"'';
  environment.systemPackages = with pkgs; [
    wineWowPackages.stagingFull
    winetricks
  ];
}
