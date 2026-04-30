{
  config,
  lib,
  ...
}:
let
  cfg = config.nixpkgsPrs;
in
{
  options.nixpkgsPrs = lib.mkOption {
    type = lib.types.listOf lib.types.ints.positive;
    default = [
      # nixos/nvidia, linuxPackages.nvidia-x11: split proprietary kernel modules, use source-built ICDs, write params via modprobe
      # merged, remove after next nixpkgs update
      498612
      # linuxPackages.nvidiaPackages.production: 595.58.03 -> 595.71.05
      514481
    ];
  };

  config = {
    patchedNixpkgs.patches = lib.mkAfter (config.lib'.pathToPatchList ../patches/nixpkgs-pr);
    perSystem =
      {
        pkgs,
        config,
        ...
      }:
      {
        packages.update-prs = pkgs.writeShellApplication {
          name = "update-prs";
          runtimeInputs = with pkgs; [
            curl
          ];
          derivationArgs = {
            preferLocalBuild = true;
            allowSubstitutes = false;
          };
          text = ''
            output_dir="''${1:-patches/nixpkgs-pr}"

            mkdir -p "$output_dir"

            shopt -s nullglob
            old_patches=("$output_dir"/*.patch)
            if ((''${#old_patches[@]})); then
              echo "Cleaning existing patch files in: $output_dir" >&2
              rm -f -- "''${old_patches[@]}"
            fi

            ${lib.concatMapStringsSep "\n" (
              p:
              let
                pr = toString p;
              in
              ''
                echo "Downloading PR #${pr}..." >&2
                url=https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/${pr}.patch
                patch_file="$output_dir/${pr}.patch"
                curl -fL --retry 3 --retry-delay 1 --output "$patch_file" "$url"
              ''
            ) cfg}

            echo "Downloaded patches to: $output_dir"
          '';
        };
        apps.update-prs = {
          type = "app";
          program = lib.getExe config.packages.update-prs;
        };
      };
  };
}
