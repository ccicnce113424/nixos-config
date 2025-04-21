{ ... }:
{
  services.mpd = {
    enable = true;
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  };
  services.mpd-mpris.enable = true;

  services.flatpak.packages = [ "dog.unix.cantata.Cantata" ];
}
