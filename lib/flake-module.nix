inputs:
{
  _module.args.lib' = {
    inherit (import ./gencfg.nix inputs) genOSConfig;
    inherit (import ./lib.nix inputs) findPkgs findPkgs';
  };
}
