{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      imports = [ "${inputs.nixpkgs}/nixos/modules/misc/nixpkgs.nix" ];
      nixpkgs = {
        hostPlatform = system;
        overlays = with inputs; [
          nur.overlays.default
          nix-packages.overlays.default
        ];
        config.allowUnfree = true;
      };
    };
}
