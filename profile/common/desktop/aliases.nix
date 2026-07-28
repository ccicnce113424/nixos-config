{
  pkgs,
  lib,
  config,
  ...
}:
{
  options.cmdAlias = lib.mkOption {
    type = lib.types.attrs;
    default = {
      # Commands to add
      sin = ''
        exec systemd-inhibit --what=sleep "$@"
      '';
      switch = ''
        set -euo pipefail
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup || true
        sin nh os switch "$@"
      '';
      cswitch = ''
        set -euo pipefail
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup || true
        sin sudo nixos-rebuild switch --flake $HOME/code/nixos-config \
          --log-format bar-with-logs -L --install-bootloader \
          --option substituters 'https://cache.nixos.org' \
          "$@"
      '';
      nb = ''
        set -euo pipefail
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup || true
        sin nh os boot "$@"
      '';
      cnb = ''
        set -euo pipefail
        rm -f $HOME/.config/fontconfig/conf.d/10-hm-fonts.conf.backup || true
        sin sudo nixos-rebuild boot --flake $HOME/code/nixos-config \
          --log-format bar-with-logs -L --install-bootloader \
          --option substituters 'https://cache.nixos.org' \
          "$@"
      '';
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
        nb "$@"
      '';
      pclean = ''
        set -euo pipefail
        echo -e "\033[1;36m:: Cleaning up old generations...\033[0m"
        sin sudo angrr run
        echo -e "\033[1;36m:: Running garbage collection...\033[0m"
        sin sudo fast-nix-gc
        echo -e "\033[1;36m:: Optimising the Nix store...\033[0m"
        sin sudo fast-nix-optimise
      '';
      clr = ''
        set -euo pipefail
        pclean
        nb "$@"
      '';
      win = ''exec systemctl reboot --boot-loader-entry=auto-windows "$@"'';
      fw = ''exec systemctl reboot --firmware-setup "$@"'';
    };
  };

  config = lib.mkIf (config.runtime.profile == "desktop") {
    environment.systemPackages = lib.mapAttrsToList pkgs.writeShellScriptBin config.cmdAlias;
  };
}
