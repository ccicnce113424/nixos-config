{
  lib,
  ...
}@input:
{
  imports = [
    ./gencfg.nix
    ./patched-nixpkgs.nix
  ];
  options.lib'.findPkgs = lib.mkOption {
    default = (import ./lib.nix input).findPkgs;
  };
}
