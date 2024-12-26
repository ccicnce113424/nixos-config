{ pkgs, ... }:
{
  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu-next";
      target-colorspace-hint = true;
      icc-profile-auto = true;
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      hwdec = "auto-safe";
      scale = "ewa_lanczos4sharpest";
      dscale = "mitchell";
      dither = "error-diffusion";
      ao = "pipewire";
      audio-file-auto = "fuzzy";
      sub-auto = "fuzzy";
    };
    scripts = [
      pkgs.mpvScripts.uosc
      pkgs.mpvScripts.mpris
    ];
  };
}
