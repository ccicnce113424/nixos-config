{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ccic-hello
  ];

  system.replaceDependencies.replacements = [ ];

  boot.kernelPatches = [
  ];
}
