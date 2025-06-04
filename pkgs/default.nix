{ pkgs, ... }:
{
  ccic-hello = pkgs.writeShellScriptBin "ccic-hello" "echo Hello, ccicnce113424!";

  shijima-qt = pkgs.callPackage ./shijima-qt { };
}
