{ pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      wineWowPackages.stagingFull
      winetricks
    ]
    ++ (with pkgs.gst_all_1; [
      gstreamer
      gst-vaapi
      gst-plugins-base
      gst-plugins-good
      gst-plugins-ugly
      gst-libav
    ]);
}
