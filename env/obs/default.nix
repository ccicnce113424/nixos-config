{ pkgs, ... }:
{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-vaapi
      obs-gstreamer
    ];
    enableVirtualCamera = true;
  };
}
