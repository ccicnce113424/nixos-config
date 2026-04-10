{
  pkgs,
  ...
}:
{
  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {
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
      mpv-unwrapped = pkgs.mpv-unwrapped.override {
        ffmpeg = pkgs.ffmpeg.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            (pkgs.fetchpatch2 {
              url = "https://code.ffmpeg.org/FFmpeg/FFmpeg/commit/672635932684c0ee7cfbb7f9eef6999b4e72df4b.patch";
              hash = "sha256-qT+ghGwpW9feV9aMVbc9pIAo4UR8qAX+M1u4EByV/tY=";
            })
          ];
        });
      };
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
  # home.packages = with pkgs; [ mpv-handler ];
}
