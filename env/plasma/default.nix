{ ... }:
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

  pkgsPatch = [
    (
      p:
      p.fetchpatch {
        name = "fix-cantata-qt-610-build.patch";
        url = "https://github.com/NixOS/nixpkgs/pull/454827.patch";
        hash = "sha256-CK+m1+qJ2GT4YnRVwEKUtstVcZhI5JCEjIhYkCgh5iw=";
      }
    )
  ];
}
