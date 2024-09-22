{
  description = "Flake for livecd";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    daeuniverse.url = "github:daeuniverse/flake.nix/release";
    daeuniverse.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs =
    inputs@{ nixpkgs, daeuniverse }:
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
            { pkgs }:
            {
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
