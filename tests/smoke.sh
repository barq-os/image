#!/usr/bin/env bash
set -Eeuo pipefail

validator=/usr/libexec/barq-os/image-smoke-test

if [[ ! -x "$validator" ]]; then
  printf 'FAIL: %s is not installed. Run this test from a booted Barq OS deployment.\n' "$validator" >&2
  exit 1
fi

exec "$validator" --live
