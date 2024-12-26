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
      slang = "zh-Hans-CN-u-sd-cmn,en";
    };
    scripts = [
      pkgs.mpvScripts.thumbfast
      pkgs.mpvScripts.uosc
      pkgs.mpvScripts.mpris
      (pkgs.mpvScripts.buildLua rec {
        name = "mpv-sub_not_forced_not_sdh";
        pname = name;
        src = pkgs.fetchzip {
          url = "https://github.com/pzim-devdata/mpv-scripts/releases/download/v0.0.1/mpv-scripts.zip";
          hash = "sha256-2FKEl3G+v/exGDGJTHIeoUQb0vrtIP8wNiUHj5MElz4=";
        };
        scriptPath = "${src}/mpv-sub_not_forced_not_sdh.lua";
      })
    ];
  };

  home.activation.mpvAutoHDR = lib.hm.dag.entryAfter [ "xdg" ] ''
    mkdir -p ~/.local/share/applications
    for file in ${config.programs.mpv.package}/share/applications/*.desktop; do
      basefile=$(basename "$file")
      target_file="$HOME/.local/share/applications/$basefile"
      cp -f "$file" "$target_file"
      sed -i 's|^Exec=|Exec=env ENABLE_HDR_WSI=1 |' "$target_file"
    done
  '';
}
