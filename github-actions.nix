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
        config.lib'.findPkgs [
          "wine-tkg-full"
        ] (builtins.head machines).value.config.environment.systemPackages
      ) grouped
    );
    attrPrefix = "githubActions.build.checks";
    platforms."x86_64-linux" = "ubuntu-latest";
  };
}
