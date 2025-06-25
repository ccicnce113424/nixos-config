username: importlist:
{ pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "vboxusers"
      "podman"
      "samba"
    ];
    shell = pkgs.zsh;
  };
  imports = importlist;
}
