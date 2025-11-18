{
  lib,
  ...
}@input:
{
  imports = [ ./gencfg.nix ];
  options.lib'.findPkgs = lib.mkOption {
    default = (import ./lib.nix input).findPkgs;
  };
}
