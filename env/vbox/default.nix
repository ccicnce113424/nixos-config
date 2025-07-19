{
  # https://github.com/NixOS/nixpkgs/issues/382233#issuecomment-2888150127
  # https://github.com/NixOS/nixpkgs/pull/409005

  pkgsPatch = [
    (
      p:
      p.fetchpatch {
        url = "https://github.com/NixOS/nixpkgs/commit/dbe1d06756992239fbbd2027ad1d6cfcef31280b.patch";
        hash = "sha256-akpVwrNMxItt5rD+S76HuOMK+NPYpz5tp+h5bB8VHN4=";
      }
    )
  ];

  virtualisation.virtualbox.host = {
    enable = true;
    enableKvm = true;
    enableExtensionPack = true;
    addNetworkInterface = false;
    enableHardening = false;
  };
}
