{ lib, ... }:
{
  imports = [
    ./plasma.nix
    ./sddm.nix
    ./fcitx5.nix
    ../modules/browsers.nix
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  # https://github.com/NixOS/nixpkgs/issues/462935
  systemd.user.services.orca.wantedBy = lib.mkForce [ ];
}
