{
  config,
  pkgs,
  lib,
  inputs',
  ...
}:
{
  programs.steam = {
    enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession = {
      enable = true;
      args = [
        "--rt"
      ] ++ lib.optional (config.networking.hostName == "ccic-desktop") "-r 165";
    };
    protontricks.enable = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
  programs.gamemode.enable = true;
  users.groups.gamemode.members = builtins.attrNames config.users.users;
  hardware.xone.enable = true;

  services.flatpak.packages = [
    "net.lutris.Lutris"
    # "com.heroicgameslauncher.hgl"
  ];

  environment.systemPackages = with pkgs; [
    # lutris
    heroic

    protonup-qt
    umu-launcher

    hmcl
    graalvmPackages.graalvm-ce

    inputs'.nix-gaming.packages.dxvk-nvapi-vkreflex-layer
  ];
}
