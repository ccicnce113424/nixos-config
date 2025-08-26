{ pkgs, config, ... }:
{
  programs.firefox = {
    enable = true;
    languagePacks = { CN = [ "zh-CN" ]; }.${config.hostCfg.locale};
    preferences = {
      # Settings for integration
      "widget.use-xdg-desktop-portal.file-picker" = 1;
      "widget.use-xdg-desktop-portal.mime-handler" = 1;
      "widget.use-xdg-desktop-portal.settings" = 1;
      "widget.use-xdg-desktop-portal.location" = 1;
      "widget.use-xdg-desktop-portal.open-uri" = 1;

      # Settings for hardware video decoding
      "media.ffmpeg.vaapi.enabled" = true;
      "widget.dmabuf.force-enabled" = true;

      # Behavior settings
      "browser.shell.checkDefaultBrowser" = false;
      "extensions.pocket.enabled" = false;
      "extensions.autoDisableScopes" = 0;
    };
    # package = pkgs.wrapFirefox pkgs.firefox-unwrapped.override {
    #   jemallocSupport = false;
    # } { };
  };

  services.speechd.enable = true;

  environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  programs.chromium.enable = true;
  environment.systemPackages = [
    (pkgs.chromium.override {
      commandLineArgs = [
        "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL,VaapiOnNvidiaGPUs,VaapiIgnoreDriverChecks"
      ];
      enableWideVine = true;
    })
  ];

  pkgsPatch = [
    (
      p:
      p.fetchpatch {
        name = "widevine-fix.patch";
        url = "https://github.com/NixOS/nixpkgs/commit/c577a4f0588042b6c6e30e9a2f267a6e3ebb97fe.patch";
        hash = "sha256-tZII6j202sNImgp40mVjJqYeOAHQDqdqYEvn2PoYWW0=";
      }
    )
  ];
}
