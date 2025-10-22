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
      "rtkit"
    ];
    shell = pkgs.zsh;
  };
  imports = importlist;
}
