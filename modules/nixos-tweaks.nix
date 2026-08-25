{
  patchedNixpkgs = {
    pins = {
    };
    overridePackagesFromMv = mv: {
      inherit (mv.at "b7c2ada94fe9") linux-firmware; # linux-firmware 20260622
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

      hardware.graphics =
        let
          mesaPkgs = pkgs.mv.at "b7c2ada94fe9"; # mesa 26.1.6
        in
        {
          package = mesaPkgs.mesa;
          package32 = mesaPkgs.pkgsi686Linux.mesa;
        };
    };
}
