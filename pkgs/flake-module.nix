{ self, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem =
    { pkgs, config, ... }:
    {
      packages = import ./default.nix { inherit pkgs; };
      overlayAttrs = config.packages;
      apps.ccic-hello = {
        type = "app";
        program = "${config.packages.ccic-hello}/bin/ccic-hello";
      };
    };
  flake.nixosModules.overlay = {
    nixpkgs.overlays = [ self.overlays.default ];
  };
}
