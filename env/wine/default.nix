{
  pkgs,
  inputs,
  ...
}:
{
  # https://github.com/NixOS/nixpkgs/issues/428236
  pkgsPatch = [
    (
      p:
      p.fetchpatch {
        url = "https://github.com/ccicnce113424/nixpkgs/commit/cebd31d1e589d4a7aef270a46073b59b7cf44d82.patch";
        hash = "sha256-viNjNXW1t1d3fVAdz+m5psJl1/cgR9POnJOsok10tME=";
      }
    )
  ];
  imports = [ inputs.nix-gaming.nixosModules.wine ];
  programs.wine = {
    enable = true;
    package = pkgs.wine-tkg-ntsync;
    binfmt = true;
    ntsync = true;
  };
  environment.systemPackages = with pkgs; [
    # following packages are from nix-gaming
    wineprefix-preparer
    winetricks-git
  ];
}
