{
  lib,
  buildLua,
  fetchFromGitHub,
  gitUpdater,
  danmakufactory,
  opencc,
}:
buildLua (finalAttrs: {
  pname = "uosc_danmaku";
  version = "1.3.1";
  scriptPath = ".";

  src = fetchFromGitHub {
    owner = "Tony15246";
    repo = "uosc_danmaku";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m+HubIlELU/COP5rgul7LBPaOEWGz2ms89mF/w3ZWGQ=";
  };

  fixupPhase = ''
    runHook preFixup

    rm -rf $out/share/mpv/scripts/uosc_danmaku/bin/DanmakuFactory/*
    ln -sf ${danmakufactory}/bin/DanmakuFactory $out/share/mpv/scripts/uosc_danmaku/bin/DanmakuFactory

    rm -rf $out/share/mpv/scripts/uosc_danmaku/bin/OpenCC_Windows
    rm -rf $out/share/mpv/scripts/uosc_danmaku/bin/OpenCC_Linux/*
    ln -sf ${opencc}/bin/opencc $out/share/mpv/scripts/uosc_danmaku/bin/OpenCC_Linux

    rm -rf $out/share/mpv/scripts/uosc_danmaku/bin/dandanplay/dandanplay.exe

    runHook postFixup
  '';

  passthru.scriptName = finalAttrs.pname;
  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "在MPV播放器中加载弹弹play弹幕";
    homepage = "https://github.com/slqy123/uosc_danmaku";
    license = lib.licenses.mit;
  };
})
