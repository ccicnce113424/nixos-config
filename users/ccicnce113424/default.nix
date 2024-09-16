{ pkgs, ... }:
{
  users.users.ccicnce113424 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };
}
