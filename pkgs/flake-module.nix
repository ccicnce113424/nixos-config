{ self, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem =
    { pkgs, config, ... }:
    {
      legacyPackages = import ./default.nix { inherit pkgs; };
      overlayAttrs = config.legacyPackages;
      apps.ccic-hello = {
        type = "app";
        program = "${config.packages.ccic-hello}/bin/ccic-hello";
      };
    };
  flake.nixosModules.overlay = {
    nixpkgs.overlays = [ self.overlays.default ];
  };
}
