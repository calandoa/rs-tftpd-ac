#!/bin/sh

cargo clean

echo '\e[1;35m' '\n\n' '========================================================== BUILD' '\e[0m'
cargo build
cargo build --bin tftpc --bin tftpd --features=client,debug_drop

echo '\e[1;35m' '\n\n' '========================================================== BUILD rel' '\e[0m'
cargo build --release
cargo build --bin tftpc --bin tftpd --features=client --release

echo '\e[1;35m' '\n\n' '========================================================== CLIPPY' '\e[0m'
cargo clippy
cargo clippy --bin tftpc --bin tftpd --features=client,debug_drop

echo '\e[1;35m' '\n\n' '========================================================== CLIPPY rel' '\e[0m'
cargo clippy --release
cargo clippy --bin tftpc --bin tftpd --features=client --release

echo '\e[1;35m' '\n\n' '========================================================== TEST' '\e[0m'
cargo test
cargo test --bin tftpc --bin tftpd --features=client,debug_drop

echo '\e[1;35m' '\n\n' '========================================================== TEST INTEG' '\e[0m'
cargo test --test integration_test --features integration --verbose -- --test-threads 1 --nocapture