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
      p.fetchpatch2 {
        name = "fix-nheko-qt-610-build.patch";
        url = "https://github.com/NixOS/nixpkgs/pull/454781.patch";
        hash = "sha256-e7RLeDzAdbThxO0ytNtfa6dsE/oy0zhEUF52Yoy07eU=";
      }
    )

    (
      p:
      p.fetchpatch2 {
        name = "fix-cantata-qt-610-build.patch";
        url = "https://github.com/NixOS/nixpkgs/pull/454827.patch";
        hash = "sha256-dLDUBVkt7bpFwuwAUEG6fbpbgAp+kKU9LNaXE78ncqQ=";
      }
    )
  ];
}
