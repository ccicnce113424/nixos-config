{
  flake.nixosModules = {
    nixos-tweaks = import ./nixos-tweaks.nix;
  };
}
