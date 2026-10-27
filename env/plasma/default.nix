{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./plasma.nix
    ./fcitx5.nix
    ../modules/browsers.nix
  ];

  config = lib.mkIf (builtins.elem "plasma" config.runtime.features) {
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    services.gaze.kde = {
      lockScreen = true;
      loginScreen = true;
      unlockKwallet = true;
      kcmPackage = pkgs.gaze-kcm;
      enableKCM = true;
    };
  };
}
