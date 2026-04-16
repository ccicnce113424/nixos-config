{ lib, config, ... }:
let
  locales = {
    CN = {
      time = {
        timeZone = "Asia/Shanghai";
      };

      i18n.defaultLocale = "zh_CN.UTF-8";
      i18n.supportedLocales = [
        "zh_CN.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
        "ja_JP.UTF-8/UTF-8"
        "C.UTF-8/UTF-8"
      ];

      nix.settings.substituters = [
        # "https://mirrors.ustc.edu.cn/nix-channels/store"
        # "https://mirror.sjtu.edu.cn/nix-channels/store"
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      ];

      networking.timeServers = [
        "ntp.aliyun.com"
        "ntp.tencent.com"
        "ntp.ntsc.ac.cn"
        "ntp.cnnic.cn"
        "cn.pool.ntp.org"
        "time.cloudflare.com"
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
