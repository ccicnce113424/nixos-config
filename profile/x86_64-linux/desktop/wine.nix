{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    wineWowPackages.stagingFull
    winetricks
    (dxvk_2.overrideAttrs (
      finalAttrs: previousAttrs: {
        patches = [
          (fetchpatch {
            url = "https://gitlab.com/Ph42oN/dxvk-gplasync/-/raw/main/patches/dxvk-gplasync-2.5.1-2.patch";
            hash = "sha256-cfMxLhz+SiLD7p7rdD/tI83hiLZxYjNgVl2034UlwDI=";
          })
        ];
      }
    ))
    vkd3d-proton
  ];
}
