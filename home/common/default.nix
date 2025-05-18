{ nixCfg, ... }:
{
  nix.settings = nixCfg;
  home.enableNixpkgsReleaseCheck = false;
}
