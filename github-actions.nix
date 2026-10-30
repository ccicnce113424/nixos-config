{
  lib,
  config,
  self,
  inputs,
  ...
}:
let
  list = lib.attrsToList self.nixosConfigurations;
  grouped = builtins.groupBy (x: x.value.pkgs.stdenv.hostPlatform.system) list;
in
{
  flake.githubActions.eval = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = builtins.mapAttrs (
      _: machines:
      builtins.listToAttrs (
        map (m: {
          inherit (m) name;
          value = m.value.config.system.build.toplevel;
        }) machines
      )
    ) grouped;
    attrPrefix = "githubActions.eval.checks";
    platforms."x86_64-linux" = "ubuntu-latest";
  };
  flake.githubActions.build = inputs.nix-github-actions.lib.mkGithubMatrix {
    checks = lib.recursiveUpdate self.checks (
      builtins.mapAttrs (
        system: machines:
        let
          groupedByName = builtins.groupBy (x: x.name) machines;
          desktop = (builtins.head groupedByName.ccic-desktop).value;
          desktopCfg = desktop.config;
          laptop = (builtins.head groupedByName.ccic-laptop).value;
          laptopCfg = laptop.config;
          replacementChecks = builtins.listToAttrs (
            map (r: {
              name = "replace-${lib.getName r.newDependency}";
              value = r.newDependency;
            }) desktopCfg.system.replaceDependencies.replacements
          );
        in
        (config.lib'.findPkgs
          [
            "virtualbox"
            "wine-tkg-full"
            "xwayland"
            "gimp-with-plugins"
            "hplip"
            # "winboat"
            "spectacle"
            "mvs"
            # "hermes-desktop"
            "reasonix"
            # "codex"
            # "cc-switch-cli"
            "omp"
            "wineprefix-preparer"
            "kdeplasma-addons"
          ]
          (desktopCfg.environment.systemPackages ++ desktopCfg.home-manager.users.ccicnce113424.home.packages)
        )
        // {
          kernel = desktopCfg.boot.kernelPackages.kernel;
        }
        // (config.lib'.findPkgs
          [
            "gaze"
          ]
          (laptopCfg.environment.systemPackages ++ laptopCfg.home-manager.users.ccicnce113424.home.packages)
        )
        // replacementChecks
        // {
          # Built straight from the flake output, not via a host's package set.
          reboot-to-windows = self.legacyPackages.${system}.reboot-to-windows;
        }
      ) grouped
    );
    attrPrefix = "githubActions.build.checks";
    platforms."x86_64-linux" = "ubuntu-latest";
  };
}
