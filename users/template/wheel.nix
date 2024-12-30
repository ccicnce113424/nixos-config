username: importlist:
{ pkgs, ... }:
{
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "plugdev"
      "libvirtd"
      "podman"
    ];
    shell = pkgs.zsh;
  };
  imports = importlist;
}
