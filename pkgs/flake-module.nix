{ self, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem =
    {
      pkgs,
      config,
      inputs',
      ...
    }:
    {
      packages = import ./default.nix { inherit pkgs inputs'; };
      overlayAttrs = config.packages;
      apps.ccic-hello = {
        type = "app";
        program = "${config.packages.ccic-hello}/bin/ccic-hello";
      };
    };
  flake.nixosModules.overlay =
    { ... }:
    {
      nixpkgs.overlays = [ self.overlays.default ];
    };
}
