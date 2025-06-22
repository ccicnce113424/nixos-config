rec {
  description = "My NixOS configuration";

  # Sources
  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
    daeuniverse = {
      url = "github:daeuniverse/flake.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        rust-overlay.follows = "rust-overlay";
      };
    };
    lan-mouse = {
      url = "github:feschber/lan-mouse";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };
    nix-packages = {
      url = "github:ccicnce113424/nix-packages";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        treefmt-nix.follows = "treefmt-nix";
        flake-compat.follows = "flake-compat";
      };
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
    flake-compat.url = "github:edolstra/flake-compat";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      _module.args = { inherit nixConfig; };
      imports = [
        ./lib/gencfg.nix
        ./modules/flake-module.nix
        ./pkgs/flake-module.nix
        ./hosts/flake-module.nix
        ./treefmt.nix
        ./livecd.nix
        ./nixpkgs.nix
      ];
      perSystem =
        { pkgs, ... }:
        {
          devShells.default = pkgs.callPackage ./devshell.nix { };
        };
    };

  nixConfig = {
    trusted-users = [ "@wheel" ];
    extra-experimental-features = [
      "nix-command"
      "flakes"
    ];
    accept-flake-config = true;
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://chaotic-nyx.cachix.org/"
      "https://numtide.cachix.org"
      "https://nix-gaming.cachix.org"

      "https://guanran928.cachix.org"
      "https://rewine.cachix.org"
      "https://rycee.cachix.org"
      "https://xddxdd.cachix.org"

      # "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8"
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="

      "guanran928.cachix.org-1:BE/iBCj2/pqJXG908wHRrcaV0B2fC+KbFjHsXY6b91c="
      "rewine.cachix.org-1:aOIg9PvwuSefg59gVXXxGIInHQI9fMpskdyya2xO+7I="
      "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A="
      "xddxdd.cachix.org-1:ay1HJyNDYmlSwj5NXQG065C8LfoqqKaTNCyzeixGjf8="

      # "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };
}
