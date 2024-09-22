{
  description = "Flake for livecd";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    daeuniverse.url = "github:daeuniverse/flake.nix/release";
    daeuniverse.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    inputs@{
      self,
      nixpkgs,
      daeuniverse,
    }:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          daeuniverse.nixosModules.daed
          (
            { pkgs, ... }:
            {
              nixpkgs.config.allowUnfree = true;
              nix.settings = {
                experimental-features = "nix-command flakes";
                substituters = [
                  "https://mirror.sjtu.edu.cn/nix-channels/store"
                  "https://cache.nixos.org"
                  "https://cache.garnix.io"
                ];
                extra-trusted-public-keys = [
                  "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
                  "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                ];
              };
              environment.systemPackages = [ pkgs.git ];
              services.daed = {
                enable = true;
                openFirewall = {
                  enable = true;
                  port = 12345;
                };
                configDir = "/etc/daed";
                listen = "127.0.0.1:2023";
              };
            }
          )
        ];
      };
    };
}
