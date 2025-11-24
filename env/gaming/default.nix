{
  config,
  pkgs,
  lib,
  host,
  inputs',
  ...
}:
{
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    extest.enable = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      luxtorpeda
    ];
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    gamescopeSession = {
      enable = true;
      args = [
        "--rt"
      ]
      ++ lib.optional (config.networking.hostName == "ccic-desktop") "-r 165";
    };
    protontricks.enable = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode.enable = true;
  users.groups.gamemode.members = host.users;

  hardware.xone.enable = true;

  hardware.xpadneo.enable = true;

  services.joycond.enable = true;

  services.flatpak.packages = [
    # "net.lutris.Lutris"
    # "com.heroicgameslauncher.hgl"
  ];

  environment.systemPackages =
    (with pkgs; [
      mangohud
      libstrangle
      lutris
      heroic
      lsfg-vk
      lsfg-vk-ui
      umu-launcher

      discord

      protonup-qt

      hmcl
    ])
    ++ (with inputs'.nix-gaming.packages; [
      dxvk-nvapi-vkreflex-layer
      (osu-lazer-tachyon-bin.override {
        pipewire_latency = "128/48000";
      })
    ]);
}
