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
      498612
      # kmscon: 9.3.3 -> 9.3.4, nixos/kmscon: remove dependency on agetty
      # merged, remove after next nixpkgs update
      508807
      # daed: 1.0.0 -> 1.27.0, add nixos module and maintainer
      510895
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
          text = ''
            output_dir="''${1:-patches/nixpkgs-pr}"

            mkdir -p "$output_dir"

            shopt -s nullglob
            old_patches=("$output_dir"/*.patch)
            if ((''${#old_patches[@]})); then
              echo "Cleaning existing patch files in: $output_dir" >&2
              rm -f -- "''${old_patches[@]}"
            fi

            for pr_number in ${toString cfg}; do
              echo "Downloading PR #$pr_number..." >&2
              url=https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/$pr_number.patch
              patch_file="$output_dir/$pr_number.patch"
              curl -fL --retry 3 --retry-delay 1 --output "$patch_file" "$url"
            done

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
