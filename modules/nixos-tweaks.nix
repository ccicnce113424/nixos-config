{
  pkgs,
  lib,
  config,
  nixConfig,
  inputs,
  ...
}:
let
  cfg = {
    environment.systemPackages =
      with pkgs;
      [
        ccic-hello
        (callPackage (inputs.fast-nix-gc.outPath + "/nix/package.nix") { })
      ]
      ++ lib.mapAttrsToList writeShellScriptBin config.cmdAlias;

    nix.settings = nixConfig // {
      extra-experimental-features = nixConfig.extra-experimental-features ++ [
        "auto-allocate-uids"
        "cgroups"
      ];
      auto-allocate-uids = true;
      system-features = [ "uid-range" ];
    };
    nix.package = config.nixPackages.nix or config.nixPackages.lix;

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
        set -euo pipefail
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup || true
        systemd-inhibit nh os switch "$@"
      '';
      cswitch = ''
        set -euo pipefail
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup || true
        systemd-inhibit sudo nixos-rebuild switch --flake $HOME/code/nixos-config \
          --log-format bar-with-logs -L --install-bootloader \
          --option substituters 'https://cache.nixos.org' \
          "$@"
      '';
      sgc = ''exec systemd-inhibit nix store gc "$@"'';
      up = ''
        set -euo pipefail
        cd $HOME/code/nixos-config

        # Record current HEAD to show what changed
        OLD_HEAD=$(git rev-parse HEAD 2>/dev/null || echo "")

        echo -e "\033[1;36m:: Fetching latest changes...\033[0m"
        systemd-inhibit git fetch origin

        if [ -n "$OLD_HEAD" ]; then
          # Show incoming commits before rebasing
          INCOMING=$(git rev-list --count "$OLD_HEAD"..origin/main 2>/dev/null || echo 0)
          if [ "$INCOMING" -gt 0 ]; then
            echo ""
            echo -e "\033[1;32mIncoming commits ($INCOMING):\033[0m"
            echo "===================="
            git --no-pager log --oneline --graph --decorate "$OLD_HEAD"..origin/main
            echo ""
            echo -e "\033[1;33mFiles changed:\033[0m"
            echo "=============="
            git --no-pager diff --stat "$OLD_HEAD"..origin/main
            echo ""
          else
            echo -e "\033[1;32mAlready up to date.\033[0m"
          fi
        fi

        git branch -f main origin/main
        git rebase origin/main
        switch "$@"
      '';
      pclean = ''
        set -euo pipefail
        echo -e "\033[1;36m:: Cleaning up old generations...\033[0m"
        systemd-inhibit sudo fast-nix-gc -d
        echo -e "\033[1;36m:: Optimising the Nix store...\033[0m"
        systemd-inhibit sudo fast-nix-optimise
      '';
      clr = ''
        set -euo pipefail
        pclean
        switch "$@"
      '';
      win = ''exec systemctl reboot --boot-loader-entry=auto-windows "$@"'';
      fw = ''exec systemctl reboot --firmware-setup "$@"'';
    };
  };
  options.enable32Bit = lib.mkEnableOption "32-bit dependencies";
  options.nixPackages = lib.mkOption {
    type = lib.types.attrs;
    # default = pkgs.lixPackageSets.latest;
    default = pkgs;
  };

  config = cfg;
}
