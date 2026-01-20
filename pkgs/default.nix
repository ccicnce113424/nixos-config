{ pkgs }:
{
  ccic-hello = pkgs.writeShellScriptBin "ccic-hello" "echo Hello, ccicnce113424!";

  chrony-dispatcher-script = pkgs.callPackage ./chrony-dispatcher-script { };
}
