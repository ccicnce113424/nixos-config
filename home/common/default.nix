{ osConfig, ... }:
{
  nix.settings = osConfig.nix.settings;
  home.enableNixpkgsReleaseCheck = false;
}
