extraModules:
{ ... }:
{
  imports = [
    ./audio.nix
    ./fonts.nix
    ./graphic.nix
    ./networking.nix
    ./utils.nix
    ./zram.nix
  ] ++ extraModules;
}
