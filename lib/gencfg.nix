{
  self,
  inputs,
  lib,
  nixConfig,
  withSystem,
  ...
}:
with inputs;
{
  _module.args.lib' = rec {

    # Configuration of system
    systemCfgs = system: if null == system then [ ] else [ ../system/${system} ];

    # Configuration of profile
    profileCfgs =
      system: profile:
      if null == system || null == profile then [ ] else [ ../profile/${system}/${profile} ];

    envCfgs = env: if null == env then [ ] else map (env: ../env/${env}) env;

    # Configuration of host
    hostCfgs =
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
          ../hosts/${hostname}
        ];

    # Configuration of users
    userCfgs =
      users:
      if null == users then
        [ ]
      else
        [
          (
            { ... }:
            {
              users.users = lib.genAttrs users (username: {
                home = "/home/${username}";
              });
            }
          )
        ]
        ++ map (username: ../users/${username}) users;

    # Configuration of Home Manager
    homeManagerCfgs =
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
                [
                  nix-flatpak.homeManagerModules.nix-flatpak
                  ../home/common
                ]
                ++ lib.optional (builtins.elem "plasma" specialArgs.host.env) plasma-manager.homeManagerModules.plasma-manager;
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
                inputs
                inputs'
                host
                nixConfig
                ;
            };
            modules =
              [
                nur.modules.nixos.default
                daeuniverse.nixosModules.daed
                nix-flatpak.nixosModules.nix-flatpak
                self.nixosModules.nixos-treaks
                self.nixosModules.overlay
              ]
              ++ systemCfgs host.system
              ++ profileCfgs host.system host.profile
              ++ envCfgs host.env
              ++ hostCfgs name
              ++ userCfgs host.users
              ++ homeManagerCfgs specialArgs;
          }
        ))
      ) hosts;
  };
}
