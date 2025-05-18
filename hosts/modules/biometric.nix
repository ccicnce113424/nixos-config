{
  pkgs,
  config,
  lib,
  ...
}:
let
  bioCfg = {
    howdy = {
      environment.systemPackages = with pkgs.nur.repos.moraxyc; [
        howdy
        linux-enable-ir-emitter
      ];
    };
  };
  cfg = config.hostCfg.biometric;
in
{
  options.hostCfg.biometric = builtins.mapAttrs (
    _: _:
    lib.mkOption {
      type = lib.types.bool;
      default = false;
    }
  ) bioCfg;
  config = lib.mkMerge (lib.mapAttrsToList (type: c: (lib.mkIf cfg.${type} c)) bioCfg);
}
