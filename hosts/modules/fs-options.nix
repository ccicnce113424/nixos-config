{ ... }:
{
  fileSystems = {
    "/efi".options = [ "umask=0077" ];
    "/boot".options = [ "umask=0077" ];
  };
}
