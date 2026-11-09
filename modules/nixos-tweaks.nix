{
  patchedNixpkgs = {
    pins = {
    };
    overridePackagesFromMv = _mv: {
    };
  };
  flake = {
    nixosModules.nixos-tweaks =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          ccic-hello
        ];

        system.replaceDependencies.replacements = [
        ];

        boot.kernelPatches = [
        ];
      };
    overlays.nixos-tweaks = _finalPkgs: prevPkgs: {
      llm-agents = prevPkgs.llm-agents // {
        # zstd-sys / onig_sys probe pkg-config; upstream omits both inputs.
        omp = prevPkgs.llm-agents.omp.overrideAttrs (prevAttrs: {
          buildInputs = prevAttrs.buildInputs ++ [
            prevPkgs.zstd
            prevPkgs.oniguruma
          ];
        });
      };
    };
  };
}
