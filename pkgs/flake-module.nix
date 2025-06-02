{ ... }:
{
  perSystem =
    {
      self',
      pkgs,
      inputs',
      ...
    }:
    {
      packages = import ./default.nix { inherit pkgs inputs'; };
      apps.ccic-hello = {
        type = "app";
        program = "${self'.packages.ccic-hello}/bin/ccic-hello";
      };
    };
}
