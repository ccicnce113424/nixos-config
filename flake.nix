{
  description = "My NixOS configuration";

  # Sources
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
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
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    inputs@{
      nixpkgs,
      nixpkgs-small,
      home-manager,
      plasma-manager,
      nur,
      daeuniverse,
      nix-flatpak,
      ...
    }:
    {
      nixosConfigurations =
        let
          # List of hosts
          hosts =
            let
              desktop-template = {
                system = "x86_64-linux";
                profile = "desktop";
                env = [
                  "plasma"
                  "gaming"
                  "obs"
                  "virt-manager"
                  "wine"
                ];
                users = [ "ccicnce113424" ];
              };
            in
            {
              ccic-desktop = desktop-template;
              ccic-laptop = desktop-template;
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

          envModules = env: (map (env: ./env/${env}) env);

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
            ++ map (username: ./users/${username}) users;

          # Configuration of Home Manager
          homeManagerModules = specialArgs: [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                backupFileExtension = "backup";
                sharedModules =
                  [
                    # nur.modules.homeManager.default    NOT NEEDED ANYMORE
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
        builtins.mapAttrs (
          name: host:
          nixpkgs.lib.nixosSystem rec {
            specialArgs = {
              inherit inputs host;
            };
            system = host.system;
            modules =
              [
                nur.modules.nixos.default
                daeuniverse.nixosModules.daed
                nix-flatpak.nixosModules.nix-flatpak
              ]
              ++ nixConfigModules
              ++ systemModules host.system
              ++ profileModules host.system host.profile
              ++ envModules host.env
              ++ hostModules name
              ++ userModules host.users
              ++ homeManagerModules specialArgs;
          }
        ) hosts
        // {
          livecd = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              (
                { pkgs, modulesPath, ... }:
                {
                  isoImage.squashfsCompression = "zstd";
                  imports = [
                    (modulesPath + "/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix")
                    ./nix-config.nix
                    daeuniverse.nixosModules.daed
                  ];
                  services.daed = {
                    enable = true;
                    openFirewall = {
                      enable = true;
                      port = 12345;
                    };
                    configDir = "/etc/daed";
                    listen = "0.0.0.0:2023";
                  };
                  networking.firewall.allowedTCPPorts = [ 2023 ];
                  environment.systemPackages = [
                    pkgs.git
                    pkgs.elinks
                  ];
                  services.openssh = {
                    enable = true;
                    settings.PermitRootLogin = "yes";
                    openFirewall = true;
                  };
                }
              )
            ];
          };
        };
    };
}
