{ lib, config, ... }:
{
  config = lib.mkIf (builtins.elem "vbox" config.runtime.features) {
    virtualisation.virtualbox.host = {
      enable = true;
      enableKvm = true;
      enableExtensionPack = true;
      addNetworkInterface = false;
      enableHardening = true;
    };
  };
}
