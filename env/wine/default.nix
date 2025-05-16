{ pkgs, ... }:
{
  boot.kernelModules = [ "ntsync" ];

  # From: https://github.com/Cat-Lady/winesync-dkms/blob/main/99-ntsync.rules
  services.udev.extraRules = ''KERNEL=="ntsync", MODE="0660", TAG+="uaccess"'';
  environment.systemPackages = with pkgs; [
    wineWowPackages.stagingFull
    winetricks
  ];
}
