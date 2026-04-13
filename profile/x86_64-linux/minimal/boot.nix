{ lib, config, ... }:
{
  imports = [
    ../../common/boot-systemd.nix
  ];

  config = lib.mkIf (config.runtime.profile == "minimal" || config.runtime.profile == "vm-test") {
    profile.bootSystemd = {
      enable = true;
    };
  };
}
