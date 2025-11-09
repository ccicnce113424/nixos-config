{ self, inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];
  perSystem =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      legacyPackages = import ./default.nix { inherit pkgs; };
      overlayAttrs = config.legacyPackages;
      apps.ccic-hello = {
        type = "app";
        program = "${config.legacyPackages.ccic-hello}/bin/ccic-hello";
      };
      packages.vbox = lib.findFirst (
        p: lib.hasPrefix "virtualbox-" p.name
      ) null self.nixosConfigurations.ccic-desktop.config.environment.systemPackages;
    };
  flake.nixosModules.overlay = {
    nixpkgs.overlays = [ self.overlays.default ];
  };
}
