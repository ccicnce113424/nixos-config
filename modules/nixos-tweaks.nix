{
  patchedNixpkgs = {
    pins = {
      electron_43 = "43.2.0";
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
