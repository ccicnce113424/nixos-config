{
  config,
  pkgs,
  lib,
  ...
}:
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
      scale = "ewa_lanczossharp";
      dscale = "mitchell";
      dither = "error-diffusion";
      ao = "pipewire";
      audio-file-auto = "fuzzy";
      sub-auto = "fuzzy";
      slang = "zh-Hans,cmn-Hans,en";
    };
    extraInput = ''
      MBTN_MID  script-binding drag-to-pan
      WHEEL_UP   script-message cursor-centric-zoom 0.1
      WHEEL_DOWN script-message cursor-centric-zoom -0.1

      # panning with the keyboard:
      # pan-image takes the following arguments
      # pan-image AXIS AMOUNT ZOOM_INVARIANT IMAGE_CONSTRAINED
      #            ^            ^                  ^
      #          x or y         |                  |
      #                         |                  |
      #   if yes, will pan by the same         if yes, stops panning if the image
      #     amount regardless of zoom             would go outside of the window

      ctrl+down  repeatable script-message pan-image y -0.1 yes yes
      ctrl+up    repeatable script-message pan-image y +0.1 yes yes
      ctrl+right repeatable script-message pan-image x -0.1 yes yes
      ctrl+left  repeatable script-message pan-image x +0.1 yes yes

      # now with more precision
      alt+down   repeatable script-message pan-image y -0.01 yes yes
      alt+up     repeatable script-message pan-image y +0.01 yes yes
      alt+right  repeatable script-message pan-image x -0.01 yes yes
      alt+left   repeatable script-message pan-image x +0.01 yes yes

      # reset the image
      ctrl+0  no-osd set video-pan-x 0; no-osd set video-pan-y 0; no-osd set video-zoom 0
      ctrl+KP0  no-osd set video-pan-x 0; no-osd set video-pan-y 0; no-osd set video-zoom 0
    '';
    profiles = {
      overwhelm = {
        scale = "bilinear";
        dscale = "bilinear";
        dither = "ordered";
        correct-downscaling = false;
      };
    };
    scripts = with pkgs.mpvScripts; [
      thumbfast
      uosc
      mpris
      sponsorblock
      mpv-image-viewer.image-positioning
    ];
  };

  home.activation.mpvAutoHDR = lib.hm.dag.entryAfter [ "xdg" ] ''
    mkdir -p ~/.local/share/applications
    for file in ${config.programs.mpv.package}/share/applications/*.desktop; do
      basefile=$(basename "$file")
      target_file="$HOME/.local/share/applications/$basefile"
      cp -f "$file" "$target_file"
      sed -i 's|^Exec=|Exec=ENABLE_HDR_WSI=1 |' "$target_file"
    done
  '';
}
