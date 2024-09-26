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
        };
      }
    ))
    vkd3d-proton
  ];
}
