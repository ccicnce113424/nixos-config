{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      imports = [ (inputs.nixpkgs.outPath + "/nixos/modules/misc/nixpkgs.nix") ];
      nixpkgs = {
        hostPlatform = system;
        overlays = [
          inputs.nur.overlays.default
          inputs.nix-packages.overlays.default
          inputs.rust-overlay.overlays.default
        ];
        config.allowUnfree = true;
      };
    };
}
