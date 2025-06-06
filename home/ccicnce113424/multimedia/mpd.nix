{ pkgs, config, ... }:
{
  services.mpd = {
    enable = true;
    extraConfig = ''
      decoder {
        plugin        "fluidsynth"
        soundfont     "${config.services.fluidsynth.soundFont}"
      }
      audio_output {
        type          "pipewire"
        name          "PipeWire Output"
        enabled       "yes"
      }
      audio_output {
        type          "alsa"
        name          "ALSA JA11 DoP Output"
        device        "hw:CARD=JA11"
        mixer_device  "pipewire"
        mixer_control "Master"
        dop           "yes"
        enabled       "no"
      }
      audio_output {
        type          "alsa"
        name          "ALSA Output (Through PipeWire)"
        mixer_device  "pipewire"
        mixer_control "Master"
        dop           "yes"
        enabled       "no"
      }
    '';
  };
  services.mpd-mpris.enable = true;

  home.packages = with pkgs; [ cantata ];
}
