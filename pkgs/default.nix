{ pkgs }:
{
  ccic-hello = pkgs.writeShellScriptBin "ccic-hello" "echo Hello, ccicnce113424!";

  nix-output-monitor = pkgs.nix-output-monitor.overrideAttrs (prev: {
    patches = prev.patches or [ ] ++ [
      (pkgs.fetchpatch2 {
        name = "fix-local-store-url-parsing.patch";
        url = "https://github.com/maralorn/nix-output-monitor/pull/203.patch";
        hash = "sha256-unpJ+tZO2HLVion7vvhj+Xn2wFOzwxnqMohPIFACX+Q=";
      })
    ];
  });
}
