{ config, pkgs, ... }:

{
  programs.appimage = {
    enable = true;
    binfmt = true;
  };
  
  services.flatpak.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    dockerSocket = true;
    networkSocket = {
      enable = true;
      openFirewall = true;
    };
    defaultNetwork.settings.dns_enabled = true;
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
}