{
  config,
  lib,
  ...
}:
{
  config = {
    patchedNixpkgs.patches = config.lib'.pathToPatchFileset ../patches/nixpkgs-pr;
    perSystem =
      {
        pkgs,
        config,
        ...
      }:
      {
        packages.nixpkgs-prs = pkgs.writeShellApplication {
          name = "nixpkgs-prs";
          runtimeInputs = with pkgs; [
            curl
            diffutils
            jq
            moreutils
          ];
          derivationArgs = {
            preferLocalBuild = true;
            allowSubstitutes = false;
          };
          text = builtins.readFile ../scripts/nixpkgs-prs.sh;
        };
        apps.nixpkgs-prs = {
          type = "app";
          program = lib.getExe config.packages.nixpkgs-prs;
        };
      };
  };
}
