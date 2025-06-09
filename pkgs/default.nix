{ pkgs }:
rec {
  ccic-hello = pkgs.writeShellScriptBin "ccic-hello" "echo Hello, ccicnce113424!";

  shijima-qt = pkgs.callPackage ./shijima-qt { };
  danmakufactory = pkgs.callPackage ./danmakufactory { };
  uosc-danmaku = pkgs.mpvScripts.callPackage ./uosc-danmaku { inherit danmakufactory; };
  playinmpv = pkgs.callPackage ./playinmpv { };
  wpsoffice-365 = pkgs.libsForQt5.callPackage ./wpsoffice-365 { };
  mpv-handler = pkgs.callPackage ./mpv-handler { };
}
