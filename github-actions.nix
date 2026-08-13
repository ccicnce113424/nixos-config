{
  lib,
  config,
  self,
  inputs,
  ...
}:
let
  list = lib.mapAttrsToList lib.nameValuePair self.nixosConfigurations;
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
        _: machines:
        let
          machine = (builtins.head machines).value;
          cfg = machine.config;
          inherit (machine) pkgs;
        in
        (
          config.lib'.findPkgs [
            "virtualbox"
            "wine-tkg-full"
            "xwayland"
            "gimp-with-plugins"
            "hplip"
            "winboat"
            "cherry-studio"
          ] (cfg.environment.systemPackages ++ cfg.home-manager.users.ccicnce113424.home.packages)
          // {
            kernel = cfg.boot.kernelPackages.kernel;
          }
        )
      ) grouped
    );
    attrPrefix = "githubActions.build.checks";
    platforms."x86_64-linux" = "ubuntu-latest";
  };
}
