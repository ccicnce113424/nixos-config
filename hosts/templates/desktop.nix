extraModules:
{ ... }:
{
  imports = [
    ../modules/locale-time-cn.nix
    ../modules/better-pipewire.nix
    ../modules/bluetooth.nix
    ../modules/tpm.nix
    ../modules/zram.nix
    ../modules/fs-options.nix
  ] ++ extraModules;
}
