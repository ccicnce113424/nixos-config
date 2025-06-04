{ lib, config, ... }:
let
  locales = {
    CN = {
      time = {
        timeZone = "Asia/Shanghai";
        # hardwareClockInLocalTime = true;
      };

      i18n.defaultLocale = "zh_CN.UTF-8";

      nix.settings.substituters = [
        # "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];
    };
  };
  cfg = config.hostCfg.locale;
in
{
  options.hostCfg.locale = lib.mkOption {
    type = lib.types.enum (builtins.attrNames locales);
    default = "CN";
  };
  config = lib.mkMerge (lib.mapAttrsToList (type: c: (lib.mkIf (cfg == type) c)) locales);
}
