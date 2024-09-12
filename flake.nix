{
  description = "My NixOS configuration";

  # Cache
  nixConfig = {
    allowUnfree = true;
    substituters = [
      "https://mirrors.ustc.edu.cn/nix-channels/store"
    ];
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # Sources
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      test-vbox = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./nix-config.nix
          ./system/x86_64-linux
          ./profile/x86_64-linux/desktop
          ./env/plasma
          { config, pkgs, ... }: { networking.hostName = "test-vbox"; }
          ./hosts/test-vbox
          ./users/ccicnce113424
          home-manager.nixosModules.home-manager {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
            };
            users.ccicnce113424 = import ./home/ccicnce113424;
          }
        ];
      };
    }
  };
}
