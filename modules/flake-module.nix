{
  flake.nixosModules = {
    nixos-tweaks = import ./nixos-tweaks.nix;
    genpkg = import ./genpkg.nix;
  };
}
