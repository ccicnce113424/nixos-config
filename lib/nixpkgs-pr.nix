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
      # treewide: fix icon by moving to valid path
      # merged, remove after the next channel update
      510472
      # kmscon: 9.3.3 -> 9.3.4-unstable-2026-04-13, nixos/kmscon: make agetty optional
      # test upcoming package and module updates
      508807
      # daed: 1.0.0 -> 1.27.0, add nixos module and maintainer
      510895
    ];
  };

  config = {
    patchedNixpkgs.patches = lib.mkAfter (map builtins.fetchurl (lib.importJSON ../nixpkgs-prs.json));
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
            nix
            jq
          ];
          text = ''
            output_file="''${1:-nixpkgs-prs.json}"

            jq -s '.' <(
              for pr_number in ${toString cfg}; do
                echo "Fetching PR #$pr_number..." >&2
                url=https://patch-diff.githubusercontent.com/raw/NixOS/nixpkgs/pull/$pr_number.patch
                sha256=$(nix store prefetch-file --json -- "$url" | jq -r .hash)
                jq -cn \
                  --arg url "$url" \
                  --arg sha256 "$sha256" \
                  '{ url: $url, sha256: $sha256 }'
              done
            ) > "$output_file"

            echo "Wrote PR patch metadata to: $output_file"
          '';
        };
        apps.update-prs = {
          type = "app";
          program = lib.getExe config.packages.update-prs;
        };
      };
  };
}
