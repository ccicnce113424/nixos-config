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
          livecd = {
            system = "x86_64-linux";
            profile = "livecd";
            env = null;
            users = null;
          };
        };

      # Configuration of system
      systemModules = system: if null == system then [ ] else [ ./system/${system} ];

      # Configuration of profile
      profileModules =
        system: profile:
        if null == system || null == profile then [ ] else [ ./profile/${system}/${profile} ];

      envModules = env: if null == env then [ ] else map (env: ./env/${env}) env;

      # Configuration of host
      hostModules =
        hostname:
        if "livecd" == hostname then
          [ ]
        else
          [
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
        if null == users then
          [ ]
        else
          [
            (
              { ... }:
              {
                users.users = nixpkgs.lib.genAttrs users (username: {
                  home = "/home/${username}";
                });
              }
            )
          ]
          ++ map (username: ./users/${username}) users;

      # Configuration of Home Manager
      homeManagerModules =
        specialArgs:
        if null == specialArgs.host.users then
          [ ]
        else
          [
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = specialArgs;
                backupFileExtension = "backup";
                sharedModules =
                  [ nix-flatpak.homeManagerModules.nix-flatpak ]
                  ++ nixpkgs.lib.optional (builtins.elem "plasma" specialArgs.host.env) plasma-manager.homeManagerModules.plasma-manager;
                users = nixpkgs.lib.genAttrs specialArgs.host.users (username: import ./home/${username});
              };
            }
            (
              { config, ... }:
              {
                home-manager.extraSpecialArgs.sysCfg = config;
              }
            )
          ];
    in
    {
      nixosConfigurations = builtins.mapAttrs (
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
              ./nix-config.nix
            ]
            ++ systemModules host.system
            ++ profileModules host.system host.profile
            ++ envModules host.env
            ++ hostModules name
            ++ userModules host.users
            ++ homeManagerModules specialArgs;
        }
      ) hosts;
    };
}
