# Barq OS

[![BlueBuild](https://github.com/barq-os/image/actions/workflows/build.yml/badge.svg)](https://github.com/barq-os/image/actions/workflows/build.yml)

**Built for the way you play.**

Barq OS is a modern Linux operating system for PC, built with a strong focus on gaming, performance, simplicity, and control.

The name **Barq** comes from the Arabic word **برق**, meaning **lightning**. It reflects the idea behind the system: fast response, smooth use, and a clean experience without unnecessary complexity.

## What is Barq OS?

Barq OS is an independent Linux project built for people who want a complete desktop operating system that is ready for gaming while still being suitable for everyday use.

It is based on Fedora Atomic technologies, uses KDE Plasma as its desktop environment, and is built as an image-based system with BlueBuild.

The goal is to provide a system that is:

- Ready for gaming
- Fast and responsive
- Easy to use
- Reliable to update
- Flexible and customizable
- Suitable for both Arabic and international users

## Gaming

Barq OS is being built with gaming as a core part of the system.

The project includes support for tools and platforms such as Steam, Proton, GameMode, MangoHud, Gamescope, Heroic Games Launcher, controllers, and modern Linux graphics technologies.

The focus is on making the gaming experience simple and practical without requiring the user to configure everything manually.

## System foundation

Barq OS uses an Atomic, image-based system design. This allows system updates to be delivered as complete system images instead of modifying the operating system package by package.

This approach is intended to make updates more predictable and to allow recovery to a previous system deployment when needed.

## Current development image

The current development image is published at:

```text
ghcr.io/barq-os/barq:latest
```

> [!WARNING]
> Barq OS is currently under active development. Development builds may change frequently and should be tested carefully before use on important hardware.

## Testing

On a compatible Fedora Atomic installation, the current Barq OS development image can be tested with:

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/barq-os/barq:latest
sudo systemctl reboot
```

After the first reboot, switch to the signed image:

```bash
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/barq-os/barq:latest
sudo systemctl reboot
```

Check the active deployment with:

```bash
rpm-ostree status
```

## Project status

Barq OS is still in early development. The core system image is working and the project is now being expanded with gaming software, system branding, installation media, hardware testing, and first-party tools.

## Independence

Barq OS is an independent Linux project. It uses open-source technologies from projects such as Fedora, KDE, and BlueBuild, but it is not an official edition or product of those projects.

## License

Repository code and configuration are licensed under the terms in [`LICENSE`](./LICENSE). Third-party software remains subject to its own licenses.

---

**Barq OS**  
**Built for the way you play.**
