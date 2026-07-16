{
  pkgs,
  # osConfig,
  ...
}:
{
  # programs.lutris = {
  #   enable = true;
  #   defaultWinePackage = osConfig.programs.wine.package;
  #   extraPackages = with pkgs; [
  #     mangohud
  #     winetricks
  #     gamescope
  #     gamemode
  #     umu-launcher
  #   ];
  #   protonPackages = osConfig.programs.steam.extraCompatPackages;
  #   steamPackage = osConfig.programs.steam.package;
  #   winePackages = [ osConfig.programs.wine.package ];
  # };

  home.packages = [
    (pkgs.olympus.override { celesteWrapper = "steam-run"; })
  ];

  programs.nixcord = {
    enable = true;
    discord = {
      vencord.enable = true;
      openASAR.enable = true;
      krisp.enable = true;
    };
  };
}
