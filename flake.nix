rec {
  description = "My NixOS configuration";

  # Sources
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # No direct use, just to keep lock clean
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs."flake-parts".follows = "flake-parts";
    };
    daeuniverse = {
      url = "github:daeuniverse/flake.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs."flake-parts".follows = "flake-parts";
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs."flake-parts".follows = "flake-parts";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      # List of hosts
      hosts = import ./hosts.nix;
    in
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, lib', ... }:
      {
        _module.args = { inherit nixConfig; };
        systems = [ "x86_64-linux" ];
        imports = [
          ./lib/gencfg.nix
          ./modules/flake-module.nix
          ./pkgs/flake-module.nix
        ];
        flake = {
          nixosConfigurations = lib'.genOSConfig hosts;
        };
      }
    );

  nixConfig = {
    trusted-users = [ "@wheel" ];
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
    accept-flake-config = true;
    extra-substituters = [
      "https://nix-community.cachix.org"
      # "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };
}
