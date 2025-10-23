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
      "audio"
      "pipewire"
    ];
    shell = pkgs.zsh;
  };
  imports = importlist;
}
