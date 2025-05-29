{
  pkgs,
  lib,
  config,
  nixConfig,
  ...
}:
let
  cfg = {
    environment.systemPackages =
      with pkgs;
      [
        git
        ccic-hello
      ]
      ++ lib.mapAttrsToList pkgs.writeShellScriptBin config.cmdAliases;

    nixpkgs.config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "olm-3.2.16"
      ];
    };

    nix.settings = nixConfig;

    system.stateVersion = lib.trivial.release;
  };
in
{
  options.cmdAliases = lib.mkOption {
    type = lib.types.attrs;
    default = {
      # Commands to add
      switch = ''
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup
        systemd-inhibit nh os switch -a $@
      '';
      cswitch = ''
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup
        systemd-inhibit sudo nixos-rebuild --fast --install-bootloader switch --option substituters \"https://cache.nixos.org\" $@
      '';
      sgc = "systemd-inhibit nix store gc $@";
      up = ''
        set -e
        cd /etc/nixos
        systemd-inhibit git pull
        switch $@
      '';
      pclean = "systemd-inhibit nh clean all $@";
      clr = ''
        set -e
        pclean
        switch $@
      '';
      win = "systemctl reboot --boot-loader-entry=auto-windows $@";
      fw = "systemctl reboot --firmware-setup $@";
    };
  };
  options.enable32Bit = lib.mkEnableOption "32-bit dependencies";

  config = cfg;
}
