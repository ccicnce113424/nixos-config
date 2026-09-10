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

      system.replaceDependencies.replacements = [ ];

      boot.kernelPatches = [
      ];
    };
}
