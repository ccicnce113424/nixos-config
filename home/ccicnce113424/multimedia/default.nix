{ pkgs, ... }:
{
  home.packages = with pkgs; [
    vlc
    netease-cloud-music-gtk
    waylyrics
    gimp
  ];

  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu-next";
      target-colorspace-hint = true;
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      hwdec = "auto-safe";
      scale = "ewa_lanczos4sharpest";
      video-sync = "display-tempo";
      interpolation = true;
      ao = "pipewire";
      sub-auto = "fuzzy";
    };
  };
}
