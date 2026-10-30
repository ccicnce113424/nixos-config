{
  stdenv,
  symlinkJoin,
  rustc,
  rustPlatform,
  cargo,
  removeReferencesTo,
}:

let
  # `-Z build-std` needs the standard library sources inside the sysroot;
  # nixpkgs' rustc does not ship them by default.
  sysroot = symlinkJoin {
    name = "rustc-with-lib-src";
    paths = [ rustc.unwrapped ];
    postBuild = ''
      mkdir -p $out/lib/rustlib/src/rust
      ln -s ${rustPlatform.rustLibSrc} $out/lib/rustlib/src/rust/library
    '';
  };
  rustcWithLibSrc = rustc.override { inherit sysroot; };
in
stdenv.mkDerivation {
  pname = "reboot-to-windows";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [
    rustcWithLibSrc
    cargo
    rustPlatform.cargoSetupHook
    rustc.llvmPackages.lld
    removeReferencesTo
  ];

  cargoDeps = rustPlatform.importCargoLock { lockFile = ./Cargo.lock; };

  # `-Z build-std` also resolves the standard library's own dependencies, so
  # merge rustc's vendored crates into the (flat) Cargo vendor directory after
  # the cargo setup hook has materialised it.
  preUnpack = ''
    copyRustVendor() {
      cp -a ${rustPlatform.rustVendorSrc}/. "$cargoDepsCopy/"
    }
    postUnpackHooks+=(copyRustVendor)
  '';

  # `-Z build-std` is a nightly feature; RUSTC_BOOTSTRAP lets the stable
  # toolchain accept it (same trick as nixpkgs' eBPF/wasm packages).
  RUSTC_BOOTSTRAP = 1;

  buildPhase = ''
    runHook preBuild

    cargo build --release --target x86_64-unknown-uefi -Z build-std=core,alloc

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 target/x86_64-unknown-uefi/release/reboot-to-windows.efi $out/reboot-to-windows.efi

    # build-std bakes its sysroot path into panic location strings; scrub the
    # store hash so the rustc closure does not leak into the system closure.
    remove-references-to -t ${sysroot} -t ${rustPlatform.rustLibSrc} \
      $out/reboot-to-windows.efi

    runHook postInstall
  '';

  meta = {
    description = "UEFI application that sets BootNext to the firmware's Windows Boot Manager entry and reboots";
    platforms = [ "x86_64-linux" ];
  };
}
