{
  pkgs,
  lib,
  config,
  nixConfig,
  ...
}:
let
  cfg = {
    environment.systemPackages = with pkgs; [
      ccic-hello
      fast-nix-gc
      nix-auth
    ];

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

    system.stateVersion = lib.trivial.release;

    system.replaceDependencies.replacements = [
    ];

    boot.kernelPatches = [
      {
        name = "fix-amdgpu-hang";
        patch = pkgs.fetchpatch {
          url = "https://github.com/torvalds/linux/commit/52f650963d8825e97a0ccdd2b616f8a01d9d3d38.patch";
          hash = "sha256-9M7jX5nPjpmn4hr5tCQ6NfasSMtzga8v9nxNtuEDAgg=";
        };
      }
    ];
  };
in
{
  options.enable32Bit = lib.mkEnableOption "32-bit dependencies";
  options.nixPackages = lib.mkOption {
    type = lib.types.attrs;
    # default = pkgs.lixPackageSets.latest;
    default = pkgs;
  };

  config = cfg;
}
