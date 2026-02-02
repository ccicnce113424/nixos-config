{
  self,
  inputs,
  lib,
  nixConfig,
  withSystem,
  ...
}:
{
  options.lib'.genOSConfig = lib.mkOption {
    default =
      let

        # Configuration of system
        systemCfgs = system: if null == system then [ ] else [ ../system/${system} ];

        # Configuration of profile
        profileCfgs =
          system: profile:
          if null == system || null == profile then [ ] else [ ../profile/${system}/${profile} ];

        envCfgs = env: if null == env then [ ] else map (env: ../env/${env}) env;

        # Configuration of host
        hostCfgs = hostname: [
          (
            { host, ... }:
            {
              networking.hostName = hostname;
              hostCfg = host.hostCfg or { };
            }
          )
          ../hosts/${hostname}
        ];

        # Configuration of users
        userCfgs =
          users:
          if null == users then
            [ ]
          else
            [
              {
                users.users = lib.genAttrs users (username: {
                  home = "/home/${username}";
                });
              }
            ]
            ++ map (username: ../users/${username}) users;

        # Configuration of Home Manager
        homeManagerCfgs =
          specialArgs:
          if null == specialArgs.host.users or null then
            [ ]
          else
            [
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = specialArgs;
                  backupFileExtension = "backup";
                  sharedModules = [
                    inputs.nix-flatpak.homeManagerModules.nix-flatpak
                    inputs.lan-mouse.homeManagerModules.default
                    inputs.nix-index-database.homeModules.nix-index
                    ../home/common
                  ]
                  ++ lib.optional (builtins.elem "plasma" specialArgs.host.env) inputs.plasma-manager.homeModules.plasma-manager;
                  users = lib.genAttrs specialArgs.host.users (username: import ../home/${username});
                };
              }
            ];

        genOSConfig =
          hosts:
          builtins.mapAttrs (
            name: host:
            (withSystem host.system (
              { inputs', ... }:
              inputs.nixpkgs.lib.nixosSystem rec {
                specialArgs = {
                  inherit
                    self
                    inputs
                    inputs'
                    host
                    nixConfig
                    ;
                };
                # system = host.system;
                modules = [
                  self.nixosModules.genpkg
                  self.nixosModules.nixos-treaks
                  inputs.chaotic.nixosModules.default
                  inputs.daeuniverse.nixosModules.daed
                  inputs.nix-flatpak.nixosModules.nix-flatpak
                  inputs.solaar.nixosModules.default
                ]
                ++ systemCfgs host.system or null
                ++ profileCfgs host.system or null host.profile or null
                ++ envCfgs host.env or null
                ++ hostCfgs name
                ++ userCfgs host.users or null
                ++ homeManagerCfgs specialArgs;
              }
            ))
          ) hosts;
      in
      genOSConfig;
  };
}
