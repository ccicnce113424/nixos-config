{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (builtins.elem "gaming" config.runtime.features) {
    hardware.steam-hardware.enable = true;
    programs.steam = {
      enable = true;
      extest.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
    };
    programs.gamescope = {
      enable = true;
    };

    programs.gamemode.enable = true;
    users.groups.gamemode.members = config.runtime.users;

    hardware.xone.enable = true;

    hardware.xpadneo.enable = true;

    # hardware.xpad-noone.enable = lib.mkForce false;

    services.joycond.enable = true;

    services.flatpak.packages = [
      # "net.lutris.Lutris"
      # "com.heroicgameslauncher.hgl"
    ];

    environment.systemPackages = with pkgs; [
      mangohud
      libstrangle
      gamescope-wsi

      # moved to user config
      # lutris

      # heroic
      lsfg-vk
      lsfg-vk-ui

      # moved to user config
      # (discord-krisp.override {
      #   withOpenASAR = true;
      # })

      # protonup-qt

      hmcl

      # following packages are from nix0gaming
      dxvk-nvapi-vkreflex-layer
      umu-launcher
      (osu-lazer-tachyon-bin.override {
        pipewire_latency = "128/48000";
      })
    ];
  };
}
