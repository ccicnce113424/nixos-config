{ ... }:
{
  imports = [
    ../minimal
  ];
  fileSystems."/efi" = {
    device = "/dev/sda1";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
      "umask=0077"
    ];
  };
  fileSystems."/" = {
    device = "/dev/sda2";
    fsType = "ext4";
    options = [ "lazytime" ];
  };
}
