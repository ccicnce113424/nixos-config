{ lib, ... }:
{
  options.fsOptions = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ "lazytime" ];
  };
  config.fileSystems = {
    "/efi".options = [ "umask=0077" ];
    "/boot".options = [ "umask=0077" ];
  };
}
