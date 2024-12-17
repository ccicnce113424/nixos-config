{ pkgs, ... }:
{
  users.users.ccicnce113424 = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "plugdev"
    ];
    shell = pkgs.zsh;
  };

  imports = [ ./daed.nix ];
}
