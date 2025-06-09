{
  lib,
  rustPlatform,
  fetchFromGitHub,
  copyDesktopItems,
}:
rustPlatform.buildRustPackage (final: {
  pname = "mpv-handler";
  version = "0.3.16";

  src = fetchFromGitHub {
    owner = "akiirui";
    repo = "mpv-handler";
    rev = "v${final.version}";
    hash = "sha256-RpfHUVZmhtneeu8PIfxinYG3/groJPA9QveDSvzU6Zo=";
  };

  cargoHash = "sha256-FrE1PSRc7GTNUum05jNgKnzpDUc3FiS5CEM18It0lYY=";

  nativeBuildInputs = [ copyDesktopItems ];
  desktopItems = [
    "${final.src}/share/linux/mpv-handler.desktop"
    "${final.src}/share/linux/mpv-handler-debug.desktop"
  ];

  meta = {
    description = "A protocol handler for mpv.";
    homepage = "https://github.com/akiirui/mpv-handler";
    license = lib.licenses.mit;
  };
})
