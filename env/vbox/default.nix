{
  virtualisation.virtualbox.host = {
    enable = true;
    enableKvm = true;
    enableExtensionPack = true;
    addNetworkInterface = false;
    enableHardening = true;
  };

  pkgsPatch = [
    (
      p:
      p.fetchpatch {
        name = "vbox-curl-fix.patch";
        url = "https://github.com/NixOS/nixpkgs/pull/450867.patch";
        hash = "sha256-C9ljliH1w1vOXPPggciN0QaH4NufTZn8pdiCXfSZXzg=";
      }
    )
    (
      p:
      p.fetchpatch {
        name = "vbox-fix-3d-acceleration.patch";
        url = "https://github.com/NixOS/nixpkgs/pull/451054.patch";
        hash = "sha256-BID9s7WL50EQyF6ckhiAjBetd3uNMi7eG5XdLKlS8CU=";
      }
    )
  ];
}
