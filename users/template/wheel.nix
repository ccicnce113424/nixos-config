username: importlist:
{ pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "plugdev"
    ];
    shell = pkgs.zsh;
  };
  imports = importlist;
}
