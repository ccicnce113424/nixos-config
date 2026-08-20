{
  pkgs,
  lib,
  config,
  nixConfig,
  ...
}:
{
  options.enable32Bit = lib.mkEnableOption "32-bit dependencies";
  options.nixPackages = lib.mkOption {
    type = lib.types.attrs;
    # default = pkgs.lixPackageSets.latest;
    default = pkgs;
  };

  config = {
    environment.systemPackages = with pkgs; [
      fast-nix-gc
      nix-auth
    ];

    system.stateVersion = lib.trivial.release;

    nix.settings = (removeAttrs nixConfig [ "extra-substituters" ]) // {
      extra-experimental-features = nixConfig.extra-experimental-features ++ [
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;
      system-features = [ "uid-range" ];
      accept-flake-config = true;
      http3 = true;
    };
    nix.package = config.nixPackages.nixVersions.latest or config.nixPackages.lix;
    nix.channel.enable = false;

    programs.direnv.angrr = {
      enable = true;
      autoUse = true;
    };
    services.angrr = {
      enable = true;
      settings = {
        temporary-root-policies = {
          direnv = {
            path-regex = "/\\.direnv/";
            period = "3d";
          };
          result = {
            path-regex = "/result[^/]*$";
            period = "0d";
          };
          pre-commit-config = {
            path-regex = "/\\.pre-commit-config\\.yaml";
            period = "3d";
          };
        };
        profile-policies.system = {
          keep-booted-system = true;
          keep-current-system = true;
          keep-latest-n = 1;
          profile-paths = [
            "/nix/var/nix/profiles/system"
          ];
        };
      };
    };
  };
}
