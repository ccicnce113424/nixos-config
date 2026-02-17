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
      ++ lib.mapAttrsToList writeShellScriptBin config.cmdAlias;

    nix.settings = nixConfig;
    nix.package = config.nixPackages.nix;
    chaotic.nyx = {
      overlay.enable = false;
      cache.enable = false;
    };

    system.stateVersion = lib.trivial.release;
  };
in
{
  options.cmdAlias = lib.mkOption {
    type = lib.types.attrs;
    default = {
      # Commands to add
      switch = ''
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup
        systemd-inhibit nh os switch "$@"
      '';
      cswitch = ''
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup
        systemd-inhibit sudo nixos-rebuild switch --flake $HOME/code/nixos-config --install-bootloader --option substituters 'https://cache.nixos.org' "$@"
      '';
      sgc = ''systemd-inhibit nix store gc "$@"'';
      up = ''
        set -e
        cd $HOME/code/nixos-config
        systemd-inhibit git pull
        switch "$@"
      '';
      pclean = ''systemd-inhibit nh clean all "$@"'';
      clr = ''
        set -e
        pclean
        switch "$@"
      '';
      win = ''systemctl reboot --boot-loader-entry=auto-windows "$@"'';
      fw = ''systemctl reboot --firmware-setup "$@"'';
    };
  };
  options.enable32Bit = lib.mkEnableOption "32-bit dependencies";
  options.nixPackages = lib.mkOption {
    type = lib.types.attrs;
    default = pkgs;
  };

  config = cfg;
}
