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
    ];
    shell = pkgs.zsh;
  };
  imports = importlist;
}
