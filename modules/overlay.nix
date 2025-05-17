{ ... }:
{
  nixpkgs.overlays = [ (final: prev: import ../pkgs { pkgs = prev; }) ];
}
