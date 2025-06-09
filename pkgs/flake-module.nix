{ self, ... }:
{
  perSystem =
    { pkgs, config, ... }:
    {
      packages = import ./default.nix { inherit pkgs; };
      apps.ccic-hello = {
        type = "app";
        program = "${config.packages.ccic-hello}/bin/ccic-hello";
      };
    };

  flake = {
    overlays.default = (_: pkgs: import ./default.nix { inherit pkgs; });
    nixosModules.overlay =
      { ... }:
      {
        nixpkgs.overlays = [ self.overlays.default ];
      };
  };
}
