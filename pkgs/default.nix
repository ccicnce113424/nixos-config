{ pkgs }:
{
  ccic-hello = pkgs.writeShellScriptBin "ccic-hello" "echo Hello, ccicnce113424!";

  # https://github.com/NixOS/nixpkgs/issues/382233#issuecomment-2888150127
  # https://github.com/NixOS/nixpkgs/pull/409005
  virtualbox = pkgs.virtualbox.overrideAttrs (oldAttrs: {
    postPatch =
      oldAttrs.postPatch
      + ''
        substituteInPlace src/VBox/Devices/Graphics/DevVGA-SVGA3d-glLdr.cpp \
        --replace-fail '"libGL.so.1"' '"${pkgs.libGL}/lib/libGL.so.1"'
      '';
  });

  animeko = pkgs.animeko.overrideAttrs (oldAttrs: {
    autoPatchelfIgnoreMissingDeps = oldAttrs.autoPatchelfIgnoreMissingDeps ++ [ "libxml2.so.2" ];
  });
}
