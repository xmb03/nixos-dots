# Rust toolchain configuration
# Manages Rust packages, cargo build optimization, and rust-analyzer
# settings for standalone .rs file analysis.

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cargo
    rustc
    rustfmt
    clippy
    rust-analyzer
    pkgs.rustPlatform.rustLibSrc
    rustlings
  ];

  home.file.".cargo/config.toml".text = ''
    [build]
    jobs = 0
    rustflags = ["-C", "target-cpu=native"]

    [profile.release]
    lto = true
    codegen-units = 1
    opt-level = 3
    strip = true

    [profile.dev]
    opt-level = 1
  '';

  home.sessionVariables = {
    CARGO_BUILD_JOBS = "0";
    CARGO_NET_RETRY = "3";
    CARGO_HTTP_TIMEOUT = "30";
    RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";
  };
}
