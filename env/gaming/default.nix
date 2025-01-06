{ config, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    extest.enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession = {
      enable = true;
      args = [
        "--rt"
      ] ++ pkgs.lib.optional (config.networking.hostName == "ccic-desktop") "-r 165";
    };
    protontricks.enable = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.gamemode.enable = true;
  hardware.xone.enable = true;

  services.flatpak.packages = [
    "net.lutris.Lutris"
    "com.heroicgameslauncher.hgl"
  ];

  environment.systemPackages = [
    # pkgs.lutris
    # pkgs.heroic
    pkgs.protonup-qt
  ];
}
