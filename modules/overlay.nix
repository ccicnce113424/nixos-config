{ inputs', ... }:
{
  nixpkgs.overlays = [
    (
      final: prev:
      import ../pkgs {
        inherit inputs';
        pkgs = final;
      }
    )
  ];
}
