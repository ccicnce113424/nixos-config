{
  pkgs,
  lib,
  ...
}:
{
  options.pkgsArch = lib.mkOption {
    type = lib.types.str;
    default = "pkgs";
  };

  config = {
    nix.registry = {
      nixpkgs-patched.to = {
        type = "path";
        path = pkgs.path;
      };
    };
  };
}
