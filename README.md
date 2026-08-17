# Barq OS

[![BlueBuild](https://github.com/barq-os/image/actions/workflows/build.yml/badge.svg)](https://github.com/barq-os/image/actions/workflows/build.yml)

**Built for the way you play.**  
**مصمم لطريقتك في اللعب.**

Barq OS is a Fedora Atomic/Kinoite-derived KDE Plasma desktop focused on gaming, performance, everyday use, freedom and control. It is an independent project and is not an official Fedora, KDE, Valve or BlueBuild product.

## Current development image

```text
ghcr.io/barq-os/barq:latest
```

> [!WARNING]
> Barq OS is in active development. `latest` is a moving development tag and has not completed the public-beta hardware and installer gates.

## Foundation

- Fedora Atomic/Kinoite base with KDE Plasma and Wayland
- Reproducible BlueBuild recipe and signed OCI image
- GameMode, MangoHud, Gamescope, Steam device rules and Fedora 44 NTSYNC integration
- Steam, Heroic and ProtonUp-Qt as user-scoped Flatpaks
- Flatseal for explicit inspection of Flatpak permissions
- Barq Gaming launcher for Steam's controller-first interface inside Plasma
- Inter, Noto Sans Arabic and JetBrains Mono from Fedora repositories
- Fedora 44 Plasma Login Manager with Barq wallpaper and supported KConfig defaults
- Barq Dark colors, Plasma defaults, session splash and lock-screen continuity
- Barq Plymouth boot/update theme with initramfs regeneration
- Barq OS identity and About System logo while retaining `ID_LIKE=fedora` and Fedora's `VERSION_ID`

Steam on Flathub is a community package rather than a Valve-supported Linux package. Flatpak sandbox permissions and runtime extensions must be tested explicitly; a host MangoHud package does not automatically provide MangoHud inside Steam Flatpak.

## Validation

Every image build executes the installed Barq image check after identity changes and before signing. A separate workflow accepts an exact published digest, verifies its Cosign signature, executes the image check inside that immutable image and runs `bootc container lint`.

On a booted Barq deployment, run:

```bash
sudo /usr/libexec/barq-os/image-smoke-test --live
```

This adds live SELinux, Wayland and Plasma Login Manager checks. It does not replace the VM and physical-device gates.

## Installer ISO candidates

The manual `installer ISO candidate` workflow builds only from an exact signed `sha256:` image digest. It uploads the ISO, checksums and Cosign signature as a short-lived development artifact. No candidate is an official installer until it passes the documented UEFI, Secure Boot, encryption, update and rollback gates.

## Before testing

Rebasing is supported only from an existing Fedora Atomic Desktop or compatible derivative. This command must already work and show an OSTree deployment:

```bash
rpm-ostree status
```

A normal Fedora KDE installation is not Atomic. Installing `rpm-ostree` manually does not convert it. Use a Fedora Kinoite installation, a virtual machine, or wait for a tested Barq installer ISO.

See [installation and rollback instructions](docs/INSTALLATION.md).

## Project documentation

- [Architecture](docs/ARCHITECTURE.md)
- [Roadmap](docs/ROADMAP.md)
- [Brand reference](docs/BRAND.md)
- [Fedora 44 identity implementation](docs/IDENTITY.md)
- [Gaming integration and console-session gate](docs/GAMING.md)
- [Deep technical report and code audit](docs/Barq_OS_Deep_Technical_Report_and_Code_2026-08-17.md)
- [Installation and rollback](docs/INSTALLATION.md)
- [Release policy](docs/RELEASE_POLICY.md)
- [Validation matrix](docs/TEST_MATRIX.md)
- [Security policy](SECURITY.md)

## Gaming support boundaries

Game compatibility is title- and publisher-dependent. EAC and BattlEye require per-title enablement by the publisher, and kernel-space anti-cheat solutions are not supported through Proton. Barq OS does not claim that every game works.

## Project status

The development image builds and is published to GHCR. Digest-pinned image verification and ISO-candidate automation are available. VM and physical installation testing, hardware validation, the licensed master Barq Mark, NVIDIA strategy, beta/stable channels and first-party Barq applications remain release work. Until the master mark is supplied, system surfaces use an explicitly temporary typographic `Barq OS` fallback rather than a fabricated lightning symbol.

## License

Repository code and configuration are licensed under [`LICENSE`](LICENSE). Third-party software and trademarks remain subject to their respective terms.
