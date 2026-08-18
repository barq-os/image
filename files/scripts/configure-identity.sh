#!/usr/bin/env bash
set -Eeuo pipefail

theme_dir=/usr/share/plymouth/themes/barq

test -f "${theme_dir}/barq.plymouth"
test -f "${theme_dir}/barq.script"
command -v plymouth-set-default-theme >/dev/null

# Select the theme here, but let BlueBuild's initramfs module perform the one
# required initramfs regeneration after all identity files have been installed.
plymouth-set-default-theme barq

# Raw files are copied after RPM transactions, so refresh the optional icon
# cache when the Fedora base provides the cache tool.
if command -v gtk-update-icon-cache >/dev/null; then
  gtk-update-icon-cache --force --ignore-theme-index /usr/share/icons/hicolor
fi
