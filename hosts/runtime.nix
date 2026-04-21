{
  config,
  lib,
  self,
  nixConfig,
  host,
  inputs,
  inputs',
  ...
}:
{
  options.runtime = {
    profile = lib.mkOption {
      type = lib.types.enum [
        "desktop"
        "minimal"
        "vm-test"
      ];
      default = "minimal";
      description = "Profile stack selector.";
    };
    homeManager.enable = lib.mkEnableOption "home-manager wiring";
    hostCfg = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Host capabilities/facts declared by hosts.nix.";
    };
    features = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Enabled feature list declared by hosts.nix.";
    };
    users = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Explicit list of enabled users for this host.";
    };
  };

  imports = [
    ../system
    ../profile
    ../env
    ../users
    inputs.home-manager.nixosModules.home-manager
  ];

  config = {
    runtime = (host.runtime or { }) // {
      hostCfg = host.hostCfg or { };
    };

    nixpkgs.flake.source = inputs.nixpkgs.outPath;

    networking.hostName = host.hostname;
    hostCfg = config.runtime.hostCfg;

    users.users = lib.genAttrs config.runtime.users (username: {
      home = "/home/${username}";
    });

    home-manager = lib.mkIf config.runtime.homeManager.enable {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit
          self
          inputs
          inputs'
          nixConfig
          host
          ;
      };
      backupFileExtension = "backup";
      sharedModules = [
        inputs.lan-mouse.homeManagerModules.default
        inputs.nix-index-database.homeModules.nix-index
        ../home/common
        inputs.plasma-manager.homeModules.plasma-manager
      ];
      users = lib.genAttrs config.runtime.users (username: import ../home/${username});
    };
  };
}
