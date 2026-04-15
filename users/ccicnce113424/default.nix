{
  lib,
  config,
  pkgs,
  ...
}:
lib.mkIf (builtins.elem "ccicnce113424" config.runtime.users) (
  import ../template/wheel.nix pkgs "ccicnce113424"
)
