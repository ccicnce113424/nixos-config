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
      scripts =
        with pkgs.mpvScripts;
        [
          thumbfast
          uosc
          mpris
          sponsorblock
          mpv-image-viewer.image-positioning
        ]
        ++ [
          pkgs.uosc-danmaku-git
        ];
      extraMakeWrapperArgs = lib.optionals host.hostCfg.gpu.nvidia or false [
        "--set"
        "ENABLE_HDR_WSI"
        "1"
      ];
    };
    scriptOpts.uosc.controls = "menu,gap,<video,audio>subtitles,<has_many_audio>audio,<has_many_video>video,<has_many_edition>editions,<stream>stream-quality,button:danmaku,cycle:toggle_on:show_danmaku@uosc_danmaku:on=toggle_on/off=toggle_off?弹幕开关,button:danmaku_menu,gap,space,<video,audio>speed,space,shuffle,loop-playlist,loop-file,gap,prev,items,next,gap,fullscreen";
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
  home.packages = with pkgs; [ mpv-handler ];
}
