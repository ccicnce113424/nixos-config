{ pkgs, ... }:
{
  home.packages = with pkgs; [
    wineWowPackages.stagingFull
    winetricks
    dxvk
    (dxvk_2.overrideAttrs (
      finalAttrs: previousAttrs: {
        patches = pkgs.fetchpatch {
          url = "https://gitlab.com/Ph42oN/dxvk-gplasync/-/raw/main/patches/dxvk-gplasync-master.patch";
          hash = "sha256-boalvYY6kBNGqA4kPzck2OAiamTa1lDrWDUVtJGQij8=";
        };
      }
    ))
    vkd3d-proton
  ];
}
