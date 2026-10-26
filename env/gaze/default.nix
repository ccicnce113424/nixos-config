{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (builtins.elem "gaze" config.runtime.features) {
    services.gaze = {
      enable = true;
      package = pkgs.gaze;
      pam.defaultServices = [
        "sudo"
        "su"
        "polkit-1"
        "login"
      ];
      gui.enable = false;
      kde = {
        lockScreen = true;
        loginScreen = true;
        unlockKwallet = true;
        kcmPackage = pkgs.gaze-kcm;
        enableKCM = true;
      };
    };
  };
}
