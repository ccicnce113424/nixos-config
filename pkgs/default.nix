{ pkgs }:
{
  ccic-hello = pkgs.writeShellScriptBin "ccic-hello" "echo Hello, ccicnce113424!";
  reboot-to-windows = pkgs.callPackage ./reboot-to-windows { };
}
