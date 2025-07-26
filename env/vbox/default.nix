{
  # https://github.com/NixOS/nixpkgs/issues/382233#issuecomment-2888150127
  # https://github.com/NixOS/nixpkgs/pull/409005

  pkgsPatch = [
    (
      p:
      p.fetchpatch {
        url = "https://github.com/NixOS/nixpkgs/commit/33853c9c64c6c1da9bc19fd0daed7bc29229250e.patch";
        hash = "sha256-VIkTvsZdRWUt8VsTKBoHqXVVJSg59kzV+B8hhSFgub8=";
      }
    )
  ];

  virtualisation.virtualbox.host = {
    enable = true;
    enableKvm = true;
    enableExtensionPack = true;
    addNetworkInterface = false;
    enableHardening = true;
  };
}
