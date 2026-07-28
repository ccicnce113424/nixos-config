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

    nix.settings = nixConfig // {
      extra-experimental-features = nixConfig.extra-experimental-features ++ [
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;
      system-features = [ "uid-range" ];
    };
    nix.package = config.nixPackages.nixVersions.latest or config.nixPackages.lix;

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

    services.selector4nix = {
      enable = true;
      configureSubstituter = "overwrite";
      settings.substituters = [
        { url = "https://cache.nixos.org"; }
      ]
      ++ (map (url: {
        inherit url;
        priority = 45;
      }) config.nix.settings.extra-substituters);
    };
  };
}
