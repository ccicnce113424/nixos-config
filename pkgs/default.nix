{ pkgs, inputs', ... }:
{
  ccic-hello = pkgs.writeShellScriptBin "ccic-hello" "echo Hello, ccicnce113424!";

  libplacebo = inputs'.nixpkgs-small.legacyPackages.libplacebo;

  shijima-qt = pkgs.callPackage ./shijima-qt { };
}
