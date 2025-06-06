{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
}:
stdenv.mkDerivation (final: {
  pname = "playinmpv";
  version = "1.0.4";
  src = fetchFromGitHub {
    owner = "diannaojiang";
    repo = "Bilibili-Playin-Mpv";
    rev = "v${final.version}";
    hash = "sha256-arz83r2uRiHWaHEhq5wVR+DvScHZdLw+C8BQFWOqyGU=";
  };

  nativeBuildInputs = [ copyDesktopItems ];

  buildPhase = ''
    runHook preBuild

    $CXX playinmpv_gcc.cpp -o playinmpv

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp playinmpv  $out/bin/playinmpv

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = final.pname;
      type = "Application";
      desktopName = final.pname;
      comment = final.meta.description;
      noDisplay = true;
      exec = "playinmpv %U";
      mimeTypes = [ "x-scheme-handler/mpv" ];
    })
  ];

  meta = {
    description = "Play Bilibili videos with MPV";
    homepage = "https://github.com/diannaojiang/Bilibili-Playin-Mpv";
    license = lib.licenses.free;
    mainProgram = "playinmpv";
  };
})
