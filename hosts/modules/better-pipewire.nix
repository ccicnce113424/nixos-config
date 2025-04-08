{ ... }:
{
  services.pipewire.extraConfig.pipewire = {
    "10-no-resample-and-low-quantum" = {
      "context.properties" = {
        "default.clock.allowed-rates" = [
          8000
          16000
          32000
          44100
          48000
          96000
          192000
          384000
        ];
        "default.clock.min-quantum" = 16;
        "default.clock.max-quantum" = 256;
        "default.clock.quantum" = 64;
      };
    };
  };
}
