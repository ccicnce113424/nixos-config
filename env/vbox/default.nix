{ pkgs, ... }:
{
  virtualisation.virtualbox.host = {
    enable = true;
    enableKvm = true;
    enableExtensionPack = true;
    addNetworkInterface = false;
    enableHardening = false;
    # https://github.com/NixOS/nixpkgs/issues/382233#issuecomment-2888150127
    # https://github.com/NixOS/nixpkgs/pull/409005
    package = pkgs.virtualbox.overrideAttrs (oldAttrs: {
      postPatch =
        oldAttrs.postPatch
        + ''
          substituteInPlace src/VBox/Devices/Graphics/DevVGA-SVGA3d-glLdr.cpp \
          --replace-fail '"libGL.so.1"' '"${pkgs.libGL}/lib/libGL.so.1"'
        '';
    });
  };
}
