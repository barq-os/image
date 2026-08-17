# Barq OS — Fedora 44 identity implementation

This document records the supported implementation of Barq's boot-to-desktop identity. It is intentionally specific to the Fedora Kinoite 44 base selected in `recipes/recipe.yml`.

## Decisions

### Plasma Login Manager, not SDDM

Fedora 44 KDE variants, including Kinoite, use Plasma Login Manager (PLM). PLM's frontend is fixed to Breeze and does not support arbitrary SDDM-style QML themes. Barq installs the supported PLM packages, enables `plasmalogin.service`, and brands the greeter through its wallpaper plus the shared Plasma color/font defaults.

Barq writes distro defaults to `/usr/lib/plasmalogin/defaults.conf`. A machine administrator can still override them through `/etc/plasmalogin.conf`; Barq does not lock the KCM with Kiosk policy.

The file carries both `WallpaperPlugin` and `WallpaperPluginId`. The first matches Fedora's initial KDE settings package, while the second is the active KConfig key in current Plasma Login Manager releases. The duplicate compatibility key is harmless and makes the Fedora 44 transition explicit.

### Plasma defaults remain user-overridable

`/etc/xdg/kdeglobals` establishes Inter, JetBrains Mono, Barq Dark, Breeze Dark icons and the minimal `org.barq.desktop` look-and-feel package. That package supplies only Barq defaults and a session splash; KDE automatically falls back to the maintained Breeze package for components Barq does not replace.

The look-and-feel default selects the `Barq` wallpaper for a fresh Plasma profile. PLM and KScreenLocker point to the same system wallpaper directly. A user's existing configuration remains higher priority than these distro defaults.

### About This System uses the product version

KInfoCenter normally reads `VERSION_ID`, which intentionally remains Fedora's `44`. Therefore `/etc/xdg/kcm-about-distrorc` explicitly sets:

```ini
[General]
LogoPath=barq-os
Name=Barq OS
Version=0.1 Development
Variant=KDE Plasma
Website=https://barqos.co
ShowBuild=true
```

This displays the Barq product version without lying to Fedora-aware tooling. `os-release` keeps `ID_LIKE=fedora` and `VERSION_ID=44`, while `VERSION`, `PRETTY_NAME` and `IMAGE_VERSION` describe Barq OS Development 0.1.

### Plymouth is regenerated in the image

`configure-identity.sh` selects the `barq` Plymouth script theme. The BlueBuild `initramfs` module then runs once, after all theme files are present and before signing. The theme implements normal boot, shutdown/restart text, boot progress, offline-update progress, visible system messages, disk-password prompts and question prompts.

Do not replace the BlueBuild module with a client-side `rpm-ostree initramfs` command. The former embeds the distro theme at image build time; the latter creates a per-machine override.

## File map

| Surface | Source files |
|---|---|
| System identity | `recipes/common/identity.yml` |
| Build ordering and initramfs | `recipes/recipe.yml` |
| PLM packages and service | `recipes/common/desktop-packages.yml`, `desktop-services.yml` |
| PLM defaults | `files/system/usr/lib/plasmalogin/defaults.conf` |
| Plasma and lock defaults | `files/system/etc/xdg/kdeglobals`, `kscreenlockerrc` |
| Color scheme | `files/system/usr/share/color-schemes/BarqDark.colors` |
| Look and feel / session splash | `files/system/usr/share/plasma/look-and-feel/org.barq.desktop/` |
| Wallpaper source and render | `files/system/usr/share/wallpapers/Barq/` |
| Plymouth | `files/system/usr/share/plymouth/themes/barq/` |
| About This System | `files/system/etc/xdg/kcm-about-distrorc` |
| Build-time assertions | `files/scripts/validate-identity.sh` |
| Installed-image assertions | `tests/smoke.sh` |

## Required runtime validation

A successful container build proves only that files, packages and initramfs generation succeeded. Before release, test a fresh VM and physical system for:

1. normal boot, shutdown and reboot;
2. a LUKS password prompt and an intentionally incorrect password;
3. offline-update progress;
4. PLM on one and two displays, including session and power actions;
5. fresh-user Plasma defaults and preservation of an existing user's choices;
6. lock/unlock, suspend/resume and logout/login;
7. KInfoCenter, `hostnamectl`, `/etc/os-release` and TTY identity;
8. English, Arabic and RTL rendering.

Run `tests/smoke.sh` inside the deployed image and attach the image digest plus hardware details to the test report.

## Master Barq Mark boundary

The supplied Brand Book defines the name, colors, typography and usage rules but does not embed the master Barq Mark. Current graphical surfaces therefore use an explicitly temporary typographic wordmark and an abstract motion wallpaper. No generic lightning symbol has been invented. When the licensed master SVG is provided, replace `barq-os.svg` and add approved monochrome exports without changing the integration paths.

## Primary references

- [Fedora 44 Plasma Login Manager change](https://fedoraproject.org/wiki/Changes/PlasmaLoginManager)
- [KDE Plasma Login Manager source and configuration](https://invent.kde.org/plasma/plasma-login-manager)
- [KDE KInfoCenter branding](https://develop.kde.org/docs/administration/kinfocenter/)
- [BlueBuild initramfs module](https://blue-build.org/reference/modules/initramfs/)
- [BlueBuild files module and Atomic `/etc` behavior](https://blue-build.org/reference/modules/files/)
