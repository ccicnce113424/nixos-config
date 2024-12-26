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
      scale = "ewa_lanczos4sharpest";
      dscale = "mitchell";
      dither = "error-diffusion";
      ao = "pipewire";
      audio-file-auto = "fuzzy";
      sub-auto = "fuzzy";
    };
    scripts = [
      pkgs.mpvScripts.thumbfast
      pkgs.mpvScripts.uosc
      pkgs.mpvScripts.mpris
    ];
  };

  home.activation.mpvAutoHDR = lib.hm.dag.entryAfter [ "xdg" ] ''
    mkdir -p ~/.local/share/applications
    for file in ${config.programs.mpv.package}/share/applications/*.desktop; do
      basefile=$(basename "$file")
      target_file="$HOME/.local/share/applications/$basefile"
      if [[ ! -f "$target_file" ]]; then
        cp "$file" "$target_file"
      fi
      sed -i 's|^Exec=|Exec=env ENABLE_HDR_WSI=1 |' "$target_file"
    done
  '';
}
