{
  pkgs,
  lib,
  host,
  ...
}:
{
  programs.mpv = {
    enable = true;
    package = pkgs.mpv-vapoursynth.override {
      scripts = with pkgs.mpvScripts; [
        thumbfast
        uosc
        mpris
        sponsorblock
        mpv-image-viewer.image-positioning
      ];
      extraMakeWrapperArgs = lib.optionals host.hostCfg.gpu.nvidia [
        "--set"
        "ENABLE_HDR_WSI"
        "1"
      ];
    };
    config = {
      vo = "gpu-next";
      target-colorspace-hint = true;
      icc-profile-auto = true;
      gpu-api = "vulkan";
      gpu-context = "waylandvk";
      hwdec = "vulkan";
      scale = "ewa_lanczossharp";
      dscale = "mitchell";
      dither = "error-diffusion";
      ao = "pipewire";
      audio-file-auto = "fuzzy";
      sub-auto = "fuzzy";
      slang = "zh-Hans,cmn-Hans,en";
      border = false;
    };
    extraInput = builtins.readFile ./input.conf;
    profiles = {
      overwhelm = {
        scale = "bilinear";
        dscale = "bilinear";
        dither = "ordered";
        correct-downscaling = false;
      };
      passthru = {
        audio-spdif = "aac,ac3,dts-hd,eac3,mp3,truehd";
      };
    };
  };
}
