{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (builtins.elem "image" config.runtime.features) {
    environment.systemPackages = with pkgs; [
      gimp
    ];

    programs.weylus = {
      enable = true;
      openFirewall = true;
      users = config.runtime.users;
    };
  };
}
