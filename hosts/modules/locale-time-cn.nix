{ ... }:
{
  time = {
    timeZone = "Asia/Shanghai";
    # hardwareClockInLocalTime = true;
  };

  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    supportedLocales = [
      "zh_CN.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "C.UTF-8/UTF-8"
    ];
  };
}
