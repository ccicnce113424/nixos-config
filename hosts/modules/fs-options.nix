{ lib, ... }:
{
  options.fsOptions = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ "lazytime" ];
  };
  options.efiOptions = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    default = [ "umask=0077" ];
  };
}
