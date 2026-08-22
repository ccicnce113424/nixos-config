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
        "polkit-1"
        "login"
      ];
      gui = {
        enable = true;
        package = pkgs.gaze-gui;
      };
      kde = {
        lockScreen = true;
        loginScreen = true;
      };
    };
  };
}
