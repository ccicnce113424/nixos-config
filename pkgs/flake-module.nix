{
  self,
  inputs,
  ...
}:
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
      overlayAttrs = config.legacyPackages;
      apps.ccic-hello = {
        type = "app";
        program = "${lib.getExe config.legacyPackages.ccic-hello}";
      };
      legacyPackages = import ./default.nix { inherit pkgs; } // {
        top-levels = lib.recurseIntoAttrs (
          builtins.mapAttrs (_: c: c.config.system.build.toplevel) self.nixosConfigurations
        );
      };
    };
  flake.nixosModules.overlay = {
    nixpkgs.overlays = [ self.overlays.default ];
  };
}
