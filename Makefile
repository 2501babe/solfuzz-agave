RUSTFLAGS:=
RUSTFLAGS+=-g
RUSTFLAGS+=-Cpasses=sancov-module
RUSTFLAGS+=-Cllvm-args=-sanitizer-coverage-inline-8bit-counters
RUSTFLAGS+=-Cllvm-args=-sanitizer-coverage-level=4
RUSTFLAGS+=-Cllvm-args=-sanitizer-coverage-pc-table
RUSTFLAGS+=-Cllvm-args=-sanitizer-coverage-trace-compares
RUSTFLAGS+=-Clink-dead-code
RUSTFLAGS+=-Cforce-frame-pointers=yes
RUSTFLAGS+=-Ctarget-feature=-crt-static
CC:=clang

RUST_VERSION?=+1.76.0

CARGO?=cargo

.PHONY: build clean toolchain

build:
	RUSTFLAGS="$(RUSTFLAGS)" $(CARGO) $(RUST_VERSION) build --target x86_64-unknown-linux-gnu --release --lib

test/self_test: test/self_test.c
	$(CC) -o $@ $< -Werror=all -pedantic -ldl -fsanitize=address,fuzzer-no-link -fsanitize-coverage=inline-8bit-counters

clean:
	$(CARGO) clean

toolchain:
	rustup toolchain install $(RUST_VERSION)
