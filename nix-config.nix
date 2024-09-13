{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
  ];
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";
  system.stateVersion = "24.05";
}