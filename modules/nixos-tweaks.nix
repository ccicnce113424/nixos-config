{
  patchedNixpkgs = {
    pins = {
    };
    overridePackagesFromMv = _mv: {
    };
  };
  flake.nixosModules.nixos-tweaks =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        ccic-hello
      ];

      system.replaceDependencies.replacements = [
        {
          oldDependency = pkgs.kdePackages.plasma-desktop;
          newDependency = pkgs.kdePackages.plasma-desktop.overrideAttrs (
            _final: prev: {
              patches = prev.patches or [ ] ++ [
                (pkgs.fetchpatch2 {
                  name = "fix-disappearing-desktop-icons.patch";
                  url = "https://github.com/KDE/plasma-desktop/commit/eb1eef2ae2201daf145b7787fe894ff03ac56ad6.patch?full_index=1";
                  hash = "sha256-i0u6NvJ9sz6Mj7KRQkxvEclJKUUubeZPNMt6/A/5jeM=";
                })
              ];
            }
          );
        }
      ];

      boot.kernelPatches = [
      ];
    };
}
