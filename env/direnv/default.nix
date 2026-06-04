{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (builtins.elem "direnv" config.runtime.features) {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv = {
        enable = true;
        package = config.nixPackages.nix-direnv;
      };
      settings = {
        global.hide_env_diff = true;
        whitelist.prefix = [ "~/code" ];
      };
    };
  };
}
