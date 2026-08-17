# Barq OS — Architecture

## Overview

Barq OS is an image-based Linux operating system built with BlueBuild on a Fedora Kinoite / KDE Plasma foundation.

The project intentionally separates the operating-system image from user applications where practical. Core system components belong in the image; suitable desktop applications can be delivered through Flatpak so they can update independently.

## Build flow

```text
GitHub repository
      ↓
BlueBuild recipe
      ↓
GitHub Actions
      ↓
Signed Barq OS image
      ↓
GitHub Container Registry
      ↓
Atomic system update / rebase
```

Current image:

```text
ghcr.io/barq-os/barq:latest
```

## Base

- Fedora major version: controlled by `recipes/recipe.yml`
- Desktop family: Fedora Kinoite
- Desktop environment: KDE Plasma
- Display stack: Wayland-first
- Build system: BlueBuild
- Image signing: Sigstore Cosign

## Package layers

### Core image

Packages that need close integration with the host operating system belong in the image. The first gaming foundation includes:

- GameMode
- MangoHud
- Gamescope

### Flatpak applications

Desktop applications that benefit from independent updates are configured as Flatpaks. The first gaming application set includes:

- Steam
- Heroic Games Launcher
- ProtonUp-Qt

## Update model

Barq OS follows an atomic image update model.

The intended lifecycle is:

```text
Upstream changes
      ↓
Barq image build
      ↓
Validation
      ↓
Development
      ↓
Beta
      ↓
Stable
```

Major Fedora transitions are controlled by the project instead of happening implicitly.

A future Barq Updater application should be a user-facing interface over the existing atomic update mechanisms and Flatpak updates rather than a replacement package manager.

## Identity

Barq OS sets its own operating-system identity while preserving `ID_LIKE=fedora` for compatibility with tooling that expects a Fedora-derived system.

The project is independent and should not present itself as an official Fedora or KDE product.

## Future components

Planned first-party components include:

- Barq Welcome
- Barq Control
- Barq Updater
- Barq branding for KDE
- Barq SDDM login theme
- Barq Plymouth boot theme
- Barq wallpapers and icon assets

Each component should be introduced only after the base image remains buildable and testable.
