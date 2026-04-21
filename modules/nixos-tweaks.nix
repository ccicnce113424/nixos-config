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
        ccic-hello
      ]
      ++ lib.mapAttrsToList writeShellScriptBin config.cmdAlias;

    nix.settings = nixConfig // {
      auto-optimise-store = true;
    };
    nix.package = config.nixPackages.nix or config.nixPackages.lix;
    chaotic.nyx = {
      overlay.enable = false;
      cache.enable = false;
    };

    programs.git.enable = true;

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
        systemd-inhibit sudo nixos-rebuild switch --flake $HOME/code/nixos-config \
          --log-format bar-with-logs -L --install-bootloader \
          --option substituters 'https://cache.nixos.org' \
          "$@"
      '';
      sgc = ''systemd-inhibit nix store gc "$@"'';
      up = ''
        set -e
        cd $HOME/code/nixos-config
        systemd-inhibit git fetch origin && git rebase main
        switch "$@"
      '';
      pclean = ''systemd-inhibit nh clean all --optimise "$@"'';
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
    default = pkgs.lixPackageSets.latest;
  };

  config = cfg;
}
