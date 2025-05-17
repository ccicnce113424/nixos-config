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
      # inputs.nixpkgs.follows = "nixpkgs";
      inputs."flake-parts".follows = "flake-parts";
    };
    nix-gaming = {
      url = "github:ccicnce113424/nix-gaming/dxvk-nvapi-vkreflex-layer";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs."flake-parts".follows = "flake-parts";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    inputs@{
      nixpkgs,
      home-manager,
      plasma-manager,
      nur,
      daeuniverse,
      nix-gaming,
      nix-flatpak,
      ...
    }:
    let
      # List of hosts
      hosts = import ./hosts.nix;
      cfgs = import ./lib/cfgs.nix inputs nixConfig;
    in
    {
      nixosConfigurations = cfgs.genOSConfig hosts;
    };

  nixConfig = {
    trusted-users = [ "@wheel" ];
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
    accept-flake-config = true;
  };
}
