username: importlist:
{ pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "podman"
      "samba"
    ];
    shell = pkgs.zsh;
  };
  imports = importlist;
}
