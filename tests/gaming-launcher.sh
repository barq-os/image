#!/usr/bin/env bash
set -Eeuo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
launcher="$repo_root/files/system/usr/libexec/barq-os/open-gaming-interface"
test_parent="${TMPDIR:-$repo_root/.test-tmp}"
mkdir -p "$test_parent"
test_root="$(mktemp -d "$test_parent/barq-gaming.XXXXXXXXXX")"
cleanup() {
  rm -rf -- "$test_root"
  rmdir -- "$test_parent" 2>/dev/null || true
}
trap cleanup EXIT

fail() {
  printf 'Gaming launcher test failed: %s\n' "$1" >&2
  exit 1
}

run_without_flatpak() {
  local case_dir="$test_root/no-flatpak"
  mkdir -p "$case_dir/bin"

  if PATH="$case_dir/bin" /bin/bash "$launcher" \
    >"$case_dir/stdout" 2>"$case_dir/stderr"; then
    fail "launcher succeeded without Flatpak"
  fi
  grep -Fq "Flatpak is not available" "$case_dir/stderr" || \
    fail "missing Flatpak error was not actionable"
}

write_flatpak_mock() {
  local target="$1"
  local info_result="$2"

  # The single-quoted variables below are intentionally written into the mock.
  # shellcheck disable=SC2016
  printf '%s\n' \
    '#!/bin/bash' \
    'set -Eeuo pipefail' \
    'printf "%s\\n" "$*" >> "$MOCK_LOG"' \
    'if [[ "$1" == info ]]; then' \
    "  exit $info_result" \
    'fi' \
    '[[ "$1" == run ]]' > "$target"
  chmod +x "$target"
}

run_without_steam() {
  local case_dir="$test_root/no-steam"
  mkdir -p "$case_dir/bin"
  write_flatpak_mock "$case_dir/bin/flatpak" 1

  if MOCK_LOG="$case_dir/calls" PATH="$case_dir/bin" /bin/bash "$launcher" \
    >"$case_dir/stdout" 2>"$case_dir/stderr"; then
    fail "launcher succeeded without user-scoped Steam"
  fi
  grep -Fq "Steam is not installed for this user" "$case_dir/stderr" || \
    fail "missing Steam error was not actionable"
  grep -Fxq "info --user com.valvesoftware.Steam" "$case_dir/calls" || \
    fail "launcher did not inspect user-scoped Steam"
}

run_with_steam() {
  local case_dir="$test_root/steam"
  mkdir -p "$case_dir/bin"
  write_flatpak_mock "$case_dir/bin/flatpak" 0

  MOCK_LOG="$case_dir/calls" PATH="$case_dir/bin" /bin/bash "$launcher" \
    >"$case_dir/stdout" 2>"$case_dir/stderr"
  grep -Fxq \
    "run com.valvesoftware.Steam steam://open/bigpicture" "$case_dir/calls" || \
    fail "launcher did not open Steam's controller interface"
}

run_without_flatpak
run_without_steam
run_with_steam
printf 'Barq Gaming launcher behavior passed all isolated cases.\n'
