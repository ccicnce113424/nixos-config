{ ... }:

{
  imports = [
    ./plasma.nix
    ./sddm.nix
    ./fcitx5.nix
    ../modules/firefox.nix
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
