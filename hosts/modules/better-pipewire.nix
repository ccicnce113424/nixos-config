{ ... }:
{
  services.pipewire.extraConfig.pipewire = {
    "10-no-resample-and-low-quantum" = {
      "context.properties" = {
        "default.clock.allowed-rates" = [
          32000
          44100
          48000
          88200
          96000
          176400
          192000
        ];
        "default.clock.min-quantum" = 64;
        "default.clock.max-quantum" = 512;
        "default.clock.quantum" = 256;
      };
    };
  };
}
