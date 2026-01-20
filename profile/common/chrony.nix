{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.chrony;
in
{
  services.chrony = {
    enable = true;
    extraFlags = [ "-s" ];
    # we set servers manually in extraConfig
    servers = [ ];
    # initstepslew is deprecated and we use `makestep` instead
    initstepslew.enabled = false;
    # we use `rtcsync` instead
    enableRTCTrimming = false;

    extraConfig = ''
      ${
        # Reference: https://github.com/NixOS/nixpkgs/blob/e4bae1bd10c9c57b2cf517953ab70060a828ee6f/nixos/modules/services/networking/ntp/ntpd-rs.nix#L75
        lib.concatMapStringsSep "\n" (
          server:
          (if lib.strings.hasInfix "pool" server then "pool " else "server ")
          + server
          + " "
          + cfg.serverOption
          + lib.optionalString (cfg.enableNTS) " nts"
        ) config.networking.timeServers
      }
      makestep 0.1 3
      rtcsync
    '';
  };

  services.timesyncd.enable = false;

  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.chrony-dispatcher-script; # pkgs/chrony-dispatcher-script/default.nix
      type = "basic";
    }
  ];
}
