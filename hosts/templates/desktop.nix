extraModules:
{ ... }:
{
  imports = [
    ../modules/locale-time-cn.nix
    ../modules/better-pipewire.nix
    ../modules/bluetooth.nix
    ../modules/tpm.nix
  ] ++ extraModules;
}
