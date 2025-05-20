{ ... }:
{
  perSystem =
    { self', pkgs, ... }:
    {
      packages = import ./default.nix pkgs;
      apps.ccic-hello = {
        type = "app";
        program = "${self'.packages.ccic-hello}/bin/ccic-hello";
      };
      formatter = pkgs.nixfmt-rfc-style;
    };
}
