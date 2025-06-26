{
  flake.nixosModules = {
    nixos-treaks = import ./nixos-treaks.nix;
    genpkg = import ./genpkg.nix;
  };
}
