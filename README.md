# Barq OS

[![Repository quality](https://github.com/barq-os/image/actions/workflows/quality.yml/badge.svg)](https://github.com/barq-os/image/actions/workflows/quality.yml)
[![BlueBuild](https://github.com/barq-os/image/actions/workflows/build.yml/badge.svg)](https://github.com/barq-os/image/actions/workflows/build.yml)

**Built for the way you play.**

Barq OS is a modern, image-based Linux desktop designed for gaming, performance and control. The current edition uses Fedora Kinoite 44, KDE Plasma and Wayland, while BlueBuild assembles and signs the reproducible operating-system image.

Barq OS is an independent project. It is not an official Fedora, KDE, Valve, Flathub or BlueBuild product.

## Development status

The current channel is **Barq OS 0.1 Development**:

```text
ghcr.io/barq-os/barq:latest
```

`latest` is a moving development tag. Use an exact digest for verification, testing and installer generation. The image and ISO automation work, but the public-beta hardware, installation and recovery gates are not complete.

## Foundation

- Fedora Kinoite 44 with KDE Plasma, Wayland and Plasma Login Manager
- Atomic deployments, transactional updates and rollback
- A split BlueBuild recipe with identity and validation applied before signing
- Cosign-signed OCI images published to GitHub Container Registry
- GameMode, MangoHud, Gamescope, Steam device rules and NTSYNC integration
- Steam, Heroic, ProtonUp-Qt and Flatseal as user-scoped Flatpaks
- A tested Barq Gaming launcher for Steam's controller-first interface inside Plasma
- SELinux Enforcing, Wayland and KDE portals as the desktop security baseline
- Barq Dark, restrained Plasma defaults, a unified wallpaper and a prompt-capable Plymouth theme
- Barq product identity while preserving Fedora lineage through `ID_LIKE=fedora` and `VERSION_ID=44`

Steam on Flathub is community maintained rather than Valve-supported. A host package is not automatically visible inside a Flatpak sandbox, so GameMode, MangoHud, external libraries and controller behavior remain explicit runtime tests.

## Validation model

Barq uses several separate evidence levels:

1. `tests/repository.sh` checks all tracked source formats, workflow pins, BlueBuild ordering, branding policy and launcher behavior.
2. The BlueBuild workflow assembles the complete image and executes its installed smoke test before signing.
3. The published-image workflow verifies an exact Cosign-signed digest, records an RPM inventory and image metadata, executes the same image test, and runs `bootc container lint`.
4. A booted deployment adds SELinux, Wayland and login-manager checks:

   ```bash
   sudo /usr/libexec/barq-os/image-smoke-test --live
   ```

5. VM and physical-device tests cover boot, installation, encryption, displays, suspend, update, rollback, controllers and real games.

CI cannot prove universal hardware compatibility or the absence of every vulnerability. Release claims are limited to recorded evidence.

## Installer candidates

The manual `installer ISO candidate` workflow accepts only an exact signed `sha256:` image digest. It verifies the image, builds the installer, enforces a 6 GiB development size ceiling, then uploads the ISO with checksums, source metadata and a Sigstore bundle. Candidates expire after 14 days and are not stable installers until the gates in [`docs/TEST_MATRIX.md`](docs/TEST_MATRIX.md) pass.

## Before testing

Rebasing is supported only from an existing Fedora Atomic Desktop or compatible derivative. This command must already show an OSTree deployment:

```bash
rpm-ostree status
```

A normal Fedora KDE installation is not Atomic. Installing the `rpm-ostree` package does not convert it. Use Fedora Kinoite, a virtual machine, or a tested Barq installer candidate.

Read the [installation and rollback guide](docs/INSTALLATION.md) before changing a deployment.

## Documentation

The complete documentation index is in [`docs/README.md`](docs/README.md). Start with:

- [Architecture](docs/ARCHITECTURE.md)
- [Technical audit](docs/TECHNICAL_AUDIT.md)
- [Security model](docs/SECURITY_MODEL.md)
- [Fedora 44 identity](docs/IDENTITY.md)
- [Gaming integration](docs/GAMING.md)
- [Release policy](docs/RELEASE_POLICY.md)
- [Validation matrix](docs/TEST_MATRIX.md)
- [Roadmap](docs/ROADMAP.md)

## Gaming support boundaries

Compatibility depends on the title, publisher, anti-cheat configuration, Proton version and hardware. EAC and BattlEye require publisher support for each title; kernel-space anti-cheat products generally do not work through Proton. Barq OS does not claim that every game works.

## Visual identity boundary

The repository does not fabricate a generic lightning symbol. Until the licensed master Barq Mark is supplied, system surfaces use a temporary typographic `Barq OS` asset and the approved Electric Minimalism colors. Third-party icon themes such as Hatter are not bundled or presented as Barq artwork.

## License

Repository code and configuration are licensed under [`LICENSE`](LICENSE). Third-party software, artwork and trademarks remain subject to their respective licenses.
