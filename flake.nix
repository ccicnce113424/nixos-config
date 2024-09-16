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
  };

  outputs = inputs @ { self, nixpkgs, home-manager, plasma-manager, ... }: 
  let
    # List of hosts
    hosts = {
      test-vbox = {
        system = "x86_64-linux";
        profile = "desktop";
        env = "plasma";
        users = [ "ccicnce113424" ];
      };
      test-vmware = {
        system = "x86_64-linux";
        profile = "desktop";
        env = "plasma";
        users = [ "ccicnce113424" ];
      };
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

    envModules = env: [
      ./env/${env}
    ];

    # Configuration of host
    hostModules = hostname: [
      ({ config, pkgs, ... }: { networking.hostName = hostname; })
      ./hosts/${hostname}
    ];

    # Configuration of users
    userModules = users: [
      ({ config, pkgs, ... }: {
        users.users = builtins.listToAttrs (map (username: {
          name = username;
          value = { home = "/home/${username}"; };
        }) users);
      })
      (map (username: ./users/${username}) users)
    ];

    # Configuration of Home Manager
    homeManagerModules = users: specialArgs: [
      home-manager.nixosModules.home-manager {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
          sharedModules = nixpkgs.lib.lists.flatten [
            (nixpkgs.lib.lists.optional (specialArgs.host.profile == "plasma") specialArgs.inputs.plasma-manager.homeManagerModules.plasma-manager )
          ];
          users = builtins.listToAttrs (map (username: {
            name = username;
            value = import ./home/${username};
          }) users);
        };
      }
    ];
  in
  {
    nixosConfigurations = builtins.listToAttrs (map (hostname: 
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
        modules = nixpkgs.lib.lists.flatten [
          nixConfigModules
          (systemModules (hosts.${hostname}.system))
          (profileModules (hosts.${hostname}.system) (hosts.${hostname}.profile))
          (envModules (hosts.${hostname}.env))
          (hostModules hostname)
          (userModules (hosts.${hostname}.users))
          (homeManagerModules (hosts.${hostname}.users) specialArgs)
        ];
      };
    }) (builtins.attrNames hosts));
  };
}
