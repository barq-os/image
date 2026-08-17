#!/usr/bin/env bash
set -euo pipefail

fail() {
  printf 'Barq identity validation failed: %s\n' "$1" >&2
  exit 1
}

expect_file() {
  test -f "$1" || fail "missing $1"
}

expect_contains() {
  grep -Fq "$2" "$1" || fail "$1 does not contain $2"
}

for package in plasma-login-manager kcm-plasmalogin plymouth-plugin-script; do
  rpm -q "$package" >/dev/null 2>&1 || fail "missing package $package"
done

systemctl is-enabled plasmalogin.service >/dev/null 2>&1 || fail "plasmalogin.service is not enabled"

expect_file /usr/lib/plasmalogin/defaults.conf
expect_contains /usr/lib/plasmalogin/defaults.conf "WallpaperPluginId=org.kde.image"
expect_contains /usr/lib/plasmalogin/defaults.conf "file:///usr/share/wallpapers/Barq/"

expect_file /etc/xdg/kdeglobals
expect_contains /etc/xdg/kdeglobals "ColorScheme=BarqDark"
expect_contains /etc/xdg/kdeglobals "LookAndFeelPackage=org.barq.desktop"

expect_file /etc/xdg/kcm-about-distrorc
expect_contains /etc/xdg/kcm-about-distrorc "LogoPath=barq-os"
expect_contains /etc/xdg/kcm-about-distrorc "Version=0.1 Development"

expect_file /usr/share/color-schemes/BarqDark.colors
expect_file /usr/share/plasma/look-and-feel/org.barq.desktop/metadata.json
expect_file /usr/share/wallpapers/Barq/contents/images/3840x2160.png
expect_file /usr/share/icons/hicolor/scalable/apps/barq-os.svg

expect_file /usr/share/plymouth/themes/barq/barq.plymouth
expect_file /usr/share/plymouth/themes/barq/barq.script
expect_contains /etc/plymouth/plymouthd.conf "Theme=barq"

# shellcheck disable=SC1091
. /etc/os-release
test "${ID-}" = barq || fail "ID is not barq"
test "${ID_LIKE-}" = fedora || fail "ID_LIKE is not fedora"
test "${VERSION_ID-}" = 44 || fail "VERSION_ID is not 44"
test "${VERSION-}" = "0.1 (Development)" || fail "VERSION is not Barq 0.1 Development"
test "${IMAGE_VERSION-}" = 0.1 || fail "IMAGE_VERSION is not 0.1"
test "${LOGO-}" = barq-os || fail "LOGO is not barq-os"

printf 'Barq Fedora 44 identity validation passed.\n'
