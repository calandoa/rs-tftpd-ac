#!/bin/sh

cargo clean

echo '\x1B[1;35m' '\n\n' '========================================================== BUILD' '\x1B[0m'
cargo build
cargo build --bin tftpc --bin tftpd --features=client,debug_drop

echo '\x1B[1;35m' '\n\n' '========================================================== BUILD rel' '\x1B[0m'
cargo build --release
cargo build --bin tftpc --bin tftpd --features=client --release

echo '\x1B[1;35m' '\n\n' '========================================================== CLIPPY' '\x1B[0m'
cargo clippy
cargo clippy --bin tftpc --bin tftpd --features=client,debug_drop

echo '\x1B[1;35m' '\n\n' '========================================================== CLIPPY rel' '\x1B[0m'
cargo clippy --release
cargo clippy --bin tftpc --bin tftpd --features=client --release

echo '\x1B[1;35m' '\n\n' '========================================================== TEST' '\x1B[0m'
cargo test
cargo test --bin tftpc --bin tftpd --features=client,debug_drop

echo '\x1B[1;35m' '\n\n' '========================================================== TEST INTEG' '\x1B[0m'
cargo test --test integration_test --features integration --verbose -- --test-threads 1 --nocapture