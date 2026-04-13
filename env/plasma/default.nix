{
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
  };
}
