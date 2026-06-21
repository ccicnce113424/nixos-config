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

    environment.systemPackages = lib.mkMerge [
      (with pkgs; [
        mangohud
        libstrangle
        gamescope-wsi

        # moved to user config
        # lutris

        heroic
        lsfg-vk
        lsfg-vk-ui

        # moved to user config
        # (discord-krisp.override {
        #   withOpenASAR = true;
        # })

        # protonup-qt

        prismlauncher

        # following packages are from nix-gaming
        umu-launcher
        (osu-lazer-tachyon-bin.override {
          pipewire_latency = "128/48000";
        })
      ])
      (lib.mkIf config.hostCfg.gpu.nvidia [ pkgs.dxvk-nvapi-vkreflex-layer ])
      (lib.mkIf config.hostCfg.gpu.amdgpu [ pkgs.low-latency-layer ])
    ];
  };
}
