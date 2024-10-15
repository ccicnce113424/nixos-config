{
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
    nur = {
      url = "github:nix-community/NUR";
    };
    daeuniverse = {
      url = "github:daeuniverse/flake.nix";
      inputs.nixpkgs.follows = "nixpkgs";
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
      nix-flatpak,
      ...
    }:
    let
      # List of hosts
      hosts = rec {
        desktop-template = {
          system = "x86_64-linux";
          profile = "desktop";
          env = [
            "plasma"
            "steam"
            "obs"
          ];
          users = [ "ccicnce113424" ];
        };
        ccic-desktop = desktop-template;
        test-vmware = desktop-template;
      };

      # Configuration of Nix and Flake
      nixConfigModules = [
        ./nix-config.nix
      ];

      # Configuration of system
      systemModules = system: [
        ./system/${system}
      ];

      # Configuration of profile
      profileModules = system: profile: [
        ./profile/${system}/${profile}
      ];

      envModules = env: map (env: ./env/${env}) env;

      # Configuration of host
      hostModules = hostname: [
        (
          { ... }:
          {
            networking.hostName = hostname;
          }
        )
        ./hosts/${hostname}
      ];

      # Configuration of users
      userModules =
        users:
        (
          [
            (
              { ... }:
              {
                users.users = builtins.listToAttrs (
                  map (username: {
                    name = username;
                    value = {
                      home = "/home/${username}";
                    };
                  }) users
                );
              }
            )
          ]
          ++ (map (username: ./users/${username}) users)
        );

      # Configuration of Home Manager
      homeManagerModules = specialArgs: [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = specialArgs;
            backupFileExtension = ".backup";
            sharedModules =
              [
                nur.hmModules.nur
                nix-flatpak.homeManagerModules.nix-flatpak
              ]
              ++ nixpkgs.lib.optional (builtins.elem "plasma" specialArgs.host.env) plasma-manager.homeManagerModules.plasma-manager;
            users = builtins.listToAttrs (
              map (username: {
                name = username;
                value = import ./home/${username};
              }) specialArgs.host.users
            );
          };
        }
      ];
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (
          hostname:
          let
            specialArgs = {
              inherit inputs;
              host = hosts.${hostname};
            };
          in
          {
            name = hostname;
            value = nixpkgs.lib.nixosSystem {
              inherit specialArgs;
              system = hosts.${hostname}.system;
              modules =
                [
                  nur.nixosModules.nur
                  daeuniverse.nixosModules.daed
                  nix-flatpak.nixosModules.nix-flatpak
                ]
                ++ nixConfigModules
                ++ (systemModules (hosts.${hostname}.system))
                ++ (profileModules (hosts.${hostname}.system) (hosts.${hostname}.profile))
                ++ (envModules (hosts.${hostname}.env))
                ++ (hostModules hostname)
                ++ (userModules (hosts.${hostname}.users))
                ++ (homeManagerModules specialArgs);
            };
          }
        ) (builtins.attrNames hosts)
      );
    };
}
