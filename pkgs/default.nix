{ pkgs }:
{
  ccic-hello = pkgs.writeShellScriptBin "ccic-hello" "echo Hello, ccicnce113424!";
  linuxPackages_6_18 = pkgs.linuxPackages_6_18.extend (
    _lfinal: lprev: {
      xpadneo = lprev.xpadneo.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (pkgs.fetchpatch {
            url = "https://github.com/orderedstereographic/xpadneo/commit/233e1768fff838b70b9e942c4a5eee60e57c54d4.patch";
            hash = "sha256-HL+SdL9kv3gBOdtsSyh49fwYgMCTyNkrFrT+Ig0ns7E=";
            stripLen = 2;
          })
        ];
      });
    }
  );
}
