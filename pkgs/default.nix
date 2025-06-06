{ pkgs, ... }:
rec {
  ccic-hello = pkgs.writeShellScriptBin "ccic-hello" "echo Hello, ccicnce113424!";

  shijima-qt = pkgs.callPackage ./shijima-qt { };
  danmakufactory = pkgs.callPackage ./danmakufactory { };
  uosc-danmaku = pkgs.callPackage ./uosc-danmaku {
    inherit danmakufactory;
    buildLua = pkgs.mpvScripts.buildLua;
  };
  playinmpv = pkgs.callPackage ./playinmpv { };
}
