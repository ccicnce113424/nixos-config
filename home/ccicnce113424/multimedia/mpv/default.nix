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
