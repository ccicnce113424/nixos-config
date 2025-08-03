{ pkgs }:
{
  ccic-hello = pkgs.writeShellScriptBin "ccic-hello" "echo Hello, ccicnce113424!";

  lixPackageSets = pkgs.lixPackageSets.extend (final: _prev: { lix_2_94 = final.git; });

  lixVersions.lix_2_93 = pkgs.lixPackageSets.latest.lix;
}
