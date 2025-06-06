{
  lib,
  stdenv,
  fetchFromGitHub,
  unstableGitUpdater,
  ...
}:
stdenv.mkDerivation (final: {
  pname = "DanmakuFactory";
  version = "0-unstable-2025-04-12";

  src = fetchFromGitHub {
    owner = "hihkm";
    repo = "DanmakuFactory";
    rev = "40fe8916f8528f57a4a1ca245d043d5c4d2566eb";
    hash = "sha256-fxp0lmvIQU7WRs0IkZHpvG73PkgAdiDMQvrGHWSsSqI=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 DanmakuFactory $out/bin/DanmakuFactory

    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "支持特殊弹幕的xml转ass格式转换工具 ";
    homepage = "https://github.com/hihkm/DanmakuFactory";
    license = lib.licenses.mit;
    mainProgram = "DanmakuFactory";
  };
})
