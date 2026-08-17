#!/usr/bin/env bash
set -Eeuo pipefail

failures=0

pass() { printf 'PASS: %s\n' "$1"; }
fail() { printf 'FAIL: %s\n' "$1" >&2; failures=$((failures + 1)); }

expect_os_release() {
  local key="$1"
  local expected="$2"
  local actual

  # shellcheck disable=SC1091
  . /etc/os-release
  actual="${!key-}"

  if [[ "$actual" == "$expected" ]]; then
    pass "$key=$expected"
  else
    fail "$key expected '$expected', got '$actual'"
  fi
}

expect_package() {
  local package="$1"
  if rpm -q "$package" >/dev/null 2>&1; then
    pass "package $package"
  else
    fail "missing package $package"
  fi
}

expect_file_contains() {
  local path="$1"
  local pattern="$2"
  if grep -Fq "$pattern" "$path"; then
    pass "$path contains $pattern"
  else
    fail "$path does not contain $pattern"
  fi
}

expect_os_release ID barq
expect_os_release ID_LIKE fedora
expect_os_release VERSION_ID 44
expect_os_release IMAGE_ID barq
expect_os_release IMAGE_VERSION 0.1

for package in gamemode mangohud gamescope steam-devices ntsync-autoload; do
  expect_package "$package"
done

expect_file_contains /etc/issue "Barq OS"
expect_file_contains /etc/xdg/kcm-about-distrorc "ShowBuild=true"

if (( failures > 0 )); then
  printf '%d Barq OS smoke check(s) failed.\n' "$failures" >&2
  exit 1
fi

printf 'All required Barq OS smoke checks passed.\n'
