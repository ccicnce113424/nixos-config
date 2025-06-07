{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    {
      imports = [ "${inputs.nixpkgs}/nixos/modules/misc/nixpkgs.nix" ];
      nixpkgs = {
        hostPlatform = system;
        overlays = [ inputs.nur.overlays.default ];
        config.allowUnfree = true;
      };
    };
}
