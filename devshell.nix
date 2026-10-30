{ pkgs, ... }:
let
  # rust-analyzer needs a toolchain that ships the UEFI target's core/alloc
  # plus rust-src, so no manual `rustup target add` / sysroot hacking is needed.
  rustToolchain = pkgs.rust-bin.stable.latest.default.override {
    targets = [ "x86_64-unknown-uefi" ];
    extensions = [
      "rust-src"
      "rust-analyzer"
    ];
  };
in
pkgs.mkShellNoCC {
  preferLocalBuild = true;
  allowSubstitutes = false;
  packages = with pkgs; [
    just
    nixd
    just-lsp

    rustToolchain
    # rustc drives `cc` for build scripts and proc-macros.
    stdenv.cc
    # `x86_64-unknown-uefi` links through `lld`.
    lld
  ];
  env = {
    RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
    # `cargo check` (and therefore rust-analyzer) must use the UEFI target:
    # the crate is `no_std`, so the host target rejects unwinding panics.
    CARGO_BUILD_TARGET = "x86_64-unknown-uefi";
  };
}
