{
  config,
  pkgs,
  lib,
  inputs',
  ...
}:
{
  hardware.steam-hardware.enable = true;
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
  hardware.xpad-noone.enable = lib.mkForce false;

  services.flatpak.packages = [
    "net.lutris.Lutris"
    # "com.heroicgameslauncher.hgl"
  ];

  environment.systemPackages =
    with pkgs;
    [
      # lutris
      heroic

      protonup-qt

      hmcl
      graalvmPackages.graalvm-ce
    ]
    ++ (with inputs'.nix-gaming.packages; [
      dxvk-nvapi-vkreflex-layer
    ])
    ++ [ inputs'.umu.packages.umu-launcher ];
}
