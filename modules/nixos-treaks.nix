{
  pkgs,
  lib,
  config,
  nixConfig,
  ...
}:
let
  # aliasPkg =
  #   {
  #     name,
  #     text,
  #     stdenvNoCC,
  #     writeShellScriptBin,
  #     copyDesktopItems,
  #     makeDesktopItem,
  #   }:
  #   stdenvNoCC.mkDerivation {
  #     name = "${name}-cmdalias";
  #     src = writeShellScriptBin name text;
  #     nativeBuildInputs = [ copyDesktopItems ];
  #     desktopItems = [
  #       (makeDesktopItem {
  #         inherit name;
  #         desktopName = name;
  #         exec = name;
  #         terminal = true;
  #         comment = "run \"${name}\"";
  #       })
  #     ];
  #     installPhase = ''
  #       runHook preInstall
  #       install -D bin/${name} $out/bin/${name}
  #       runHook postInstall
  #     '';
  #   };
  cfg = {
    environment.systemPackages =
      with pkgs;
      [
        git
        ccic-hello
      ]
      # ++ lib.mapAttrsToList (
      #   name: text: pkgs.callPackage aliasPkg { inherit name text; }
      # ) config.cmdAlias;
      ++ lib.mapAttrsToList writeShellScriptBin config.cmdAlias;

    nix.settings = nixConfig;
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
        systemd-inhibit nh os switch $@
      '';
      cswitch = ''
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup
        systemd-inhibit sudo nixos-rebuild switch --flake $HOME/code/nixos-config --install-bootloader --option substituters 'https://cache.nixos.org' $@
      '';
      sgc = "systemd-inhibit nix store gc $@";
      up = ''
        set -e
        cd $HOME/code/nixos-config
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
