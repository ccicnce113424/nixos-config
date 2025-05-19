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
      [ git ] ++ lib.mapAttrsToList pkgs.writeShellScriptBin config.cmdAliases;

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
      switch = "systemd-inhibit sudo nixos-rebuild --fast --install-bootloader switch $@";
      cswitch = "switch --option substituters \"https://cache.nixos.org\" $@";
      gc = "nix store gc $@";
      up = ''
        set -e
        cd /etc/nixos
        git pull
        switch $@
      '';
      fup = "nix flake update --commit-lock-file $@";
      clean = "sudo nix profile wipe-history --profile /nix/var/nix/profiles/system $@";
      clr = ''
        set -e
        clean
        switch $@
        gc
      '';
      win = "systemctl reboot --boot-loader-entry=auto-windows $@";
      fw = "systemctl reboot --firmware-setup $@";
    };
  };
  options.enable32Bit = lib.mkOption {
    type = lib.types.bool;
    default = false;
  };

  config = cfg;
}
