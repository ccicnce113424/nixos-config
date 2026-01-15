{ pkgs, osConfig, ... }:
{
  programs.lutris = {
    enable = true;
    defaultWinePackage = osConfig.programs.wine.package;
    extraPackages = with pkgs; [
      mangohud
      winetricks
      gamescope
      gamemode
      umu-launcher
    ];
    protonPackages = osConfig.programs.steam.extraCompatPackages;
    steamPackage = osConfig.programs.steam.package;
    winePackages = [ osConfig.programs.wine.package ];
  };

  programs.discord = {
    enable = true;
    package = pkgs.discord-krisp.override {
      withOpenASAR = true;
    };
    settings = {
      DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
    };
  };
}
