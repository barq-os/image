# Barq OS — Architecture

## Overview

Barq OS is a bootable, image-based Linux desktop built with BlueBuild on Fedora Kinoite and KDE Plasma. The product identity is Barq OS; Fedora remains the technical compatibility base.

```text
recipes + files/system + policy
              ↓
        BlueBuild CI
              ↓
      signed OCI image
              ↓
             GHCR
              ↓
  install / rebase / update / rollback
```

Current development image:

```text
ghcr.io/barq-os/barq:latest
```

## Layers

### Host image

KDE, drivers, system services, GameMode, Gamescope, MangoHud, `steam-devices`, `ntsync-autoload`, fonts, udev rules and Barq identity belong to the host image.

### Flatpak

Steam, Heroic and ProtonUp-Qt are user-scoped Flatpaks so applications can update independently. Flatpak sandbox permissions and matching runtime extensions remain explicit test boundaries.

### User and development data

User data belongs in `/var/home`. Development tools should normally use Toolbx or Distrobox instead of permanently layering toolchains into the operating-system image.

## Update implementation

Fedora Atomic currently exposes deployment, update and rollback through `rpm-ostree`; the underlying bootable-container direction increasingly uses bootc. Documentation must describe the behavior actually present in the selected base image rather than claiming that installing either command converts a mutable Fedora system.

## Identity

`os-release` is applied near the end of the build. Barq sets `ID=barq`, `IMAGE_ID=barq` and `IMAGE_VERSION`, while preserving `ID_LIKE=fedora` and Fedora's `VERSION_ID` for base compatibility.

## Signing and Secure Boot

Cosign verifies the OCI image in the registry. UEFI Secure Boot verifies the device boot chain and kernel modules. These are separate controls; a valid image signature is not proof that local third-party modules are enrolled or trusted.

## Desktop direction

Fedora 44 KDE installations use Plasma Login Manager and Plasma Setup. Barq is PLM-first; an SDDM theme is only a compatibility path for older deployments. Plasma Union remains experimental and is not a Barq 1.0 dependency.

Barq Welcome should complement Plasma Setup rather than duplicate accounts, networking, language or time setup. Barq Control should use an unprivileged Kirigami interface and a narrow KAuth/polkit or D-Bus helper for privileged operations. Barq Updater is deferred until a tested gap remains after Discover, Flatpak and Atomic update integration.

## Hardware

AMD and Intel follow Fedora's kernel and Mesa updates. NVIDIA must not be injected into the generic image without a separate supported recipe, driver/Secure Boot design and hardware matrix.

## Release model

Development, beta and stable channels promote the same tested digest instead of rebuilding different bits. See `RELEASE_POLICY.md` and `TEST_MATRIX.md`.
