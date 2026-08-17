# Barq OS

[![BlueBuild](https://github.com/barq-os/image/actions/workflows/build.yml/badge.svg)](https://github.com/barq-os/image/actions/workflows/build.yml)

**Built for the way you play.**

Barq OS is a modern Linux operating system designed around **gaming, performance, simplicity, freedom, and control**. It is built on Fedora Atomic technologies, uses KDE Plasma as its desktop, and is assembled as a reproducible system image with BlueBuild.

> **Barq** means **lightning** — **برق** in Arabic. The name represents speed, instant response, energy, and motion. Those ideas define how Barq OS should feel: fast to respond, fluid to use, clean in design, and focused on what matters.

**Energy in motion. — طاقة في حركة.**

---

## What is Barq OS?

Barq OS is an independent Linux project for PC users who want a polished desktop that is ready for gaming while remaining useful for everyday computing.

The project is being designed around four core pillars:

- **Performance** — keep the system responsive and efficient from boot to gameplay.
- **Play** — make gaming a first-class part of the operating system instead of an afterthought.
- **Freedom** — build on Linux and open-source technologies without locking users into a closed ecosystem.
- **Control** — give users a powerful KDE Plasma desktop and ownership of how their machine works.

Barq OS has an Arabic identity, but it is designed for everyone. That identity appears naturally through the name **Barq / برق**, release names, strong Arabic language support, RTL quality, and the visual character of the project rather than through a regional limitation on who the system is for.

---

## Project direction

Barq OS is currently being developed as a gaming-focused Fedora Atomic desktop with KDE Plasma.

The initial system target includes:

- Fedora Atomic / Kinoite foundation
- KDE Plasma desktop
- Wayland session
- Atomic image-based system updates
- Rollback to a previous deployment when needed
- Signed system images
- Steam and Proton
- GameMode
- MangoHud
- Gamescope
- Heroic Games Launcher
- Controller support
- AMD, Intel, and NVIDIA gaming support as the project matures
- Barq visual identity and first-party system tools

The first priority is to build a reliable complete operating system. Advanced Barq-specific gaming automation can be explored later after the core system is stable.

---

## Visual identity

Barq OS uses a design language called **Electric Minimalism**.

The visual system combines deep neutral surfaces, precise geometry, clean typography, generous spacing, and restrained electric-blue accents. Blue is used to communicate active states, focus, progress, and energy rather than filling every surface.

Core visual values:

- **Fast**
- **Refined**
- **Powerful**
- **Fluid**
- **Focused**
- **Modern**
- **Personal**

The visual direction avoids loud RGB styling, excessive glow, unnecessary animation, and exaggerated “extreme gaming” language.

Primary colors:

| Token | Value | Role |
|---|---:|---|
| Barq Midnight | `#050814` | Main dark background |
| Barq Surface | `#0B1220` | Panels and elevated surfaces |
| Barq Blue | `#1A7BFF` | Primary active accent |
| Electric Cyan | `#22D7FF` | Motion and secondary highlight |
| Ice | `#EAF2FF` | Primary text/icons on dark surfaces |
| Pure White | `#FFFFFF` | High-emphasis neutral |

Primary tagline:

> **Built for the way you play.**
>
> **مصمم لطريقتك في اللعب.**

---

## Current development image

The Barq OS development image is published to GitHub Container Registry:

```text
ghcr.io/barq-os/barq:latest
```

The current Fedora major version is pinned in [`recipes/recipe.yml`](./recipes/recipe.yml) so the project controls when a major Fedora transition happens.

> [!WARNING]
> Barq OS is currently in early development. Development images may change frequently and should not be used on a machine containing important data without a backup.

---

## Testing on Fedora Atomic

To test Barq OS from an existing compatible Fedora Atomic installation, first rebase to the unverified image. This installs the Barq signing policy and public key into the deployment:

```bash
sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/barq-os/barq:latest
sudo systemctl reboot
```

After rebooting, switch to the signed image:

```bash
sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/barq-os/barq:latest
sudo systemctl reboot
```

Check the active deployment with:

```bash
rpm-ostree status
```

---

## Image signing

Barq OS images are signed with Sigstore Cosign. The public verification key is stored in [`cosign.pub`](./cosign.pub).

To verify a published image:

```bash
cosign verify --key cosign.pub ghcr.io/barq-os/barq
```

The private signing key is never stored in this repository.

---

## Updates

Barq OS is built through GitHub Actions. Changes to the system recipe produce a new system image, and scheduled builds can pull in upstream fixes and package updates while keeping the Fedora major version under project control.

The intended release flow is:

```text
Development → Beta → Stable
```

System image updates and application updates are kept conceptually separate. Core OS components are delivered through the Barq system image, while suitable desktop applications can be delivered and updated through Flatpak.

A dedicated **Barq Updater** interface is planned for later development. It will present system and application updates in one clear interface while relying on the underlying atomic update mechanisms rather than inventing a separate package-management model.

---

## Gaming stack

The first Barq gaming foundation is planned around proven Linux gaming components rather than custom performance claims:

- **Steam** — primary PC game platform
- **Proton** — Windows-game compatibility through Steam
- **GameMode** — temporary performance-oriented system tuning while games run
- **MangoHud** — performance monitoring and metrics overlay
- **Gamescope** — gaming-focused compositor and display tooling
- **Heroic Games Launcher** — access to supported non-Steam game libraries

Barq OS will prioritize stability and compatibility before adding complex automatic optimization systems.

---

## Planned first-party experience

As the base system matures, Barq OS is expected to include first-party tools such as:

- **Barq Welcome** — first-run setup and onboarding
- **Barq Control** — Barq-specific gaming, performance, hardware, and system controls
- **Barq Updater** — a focused interface for atomic system updates and application updates

These tools should complement KDE System Settings rather than duplicate it.

---

## Repository structure

```text
image/
├── .github/
│   └── workflows/       # automated image builds
├── files/               # files copied into the system image
├── modules/             # reusable BlueBuild module configuration
├── recipes/             # Barq OS image recipes
├── cosign.pub            # public image-signing key
├── LICENSE
└── README.md
```

The project will grow this structure gradually as each subsystem is implemented and tested.

---

## Release naming

Barq OS releases use Arabic-rooted names related to light, sky, and motion.

Planned naming direction includes:

- **Fajr — فجر**
- **Noor — نور**
- **Madar — مدار**
- **Najm — نجم**
- **Sahab — سحاب**
- **Shorouq — شروق**

The planned first major release name is:

```text
Barq OS 1.0 — Fajr
```

---

## Project status

Barq OS is in active early development.

Current foundation:

- [x] GitHub organization created
- [x] Core image repository created
- [x] Fedora Kinoite / KDE base selected
- [x] BlueBuild image recipe created
- [x] Cosign signing configured
- [x] Initial image published to GHCR
- [ ] Gaming packages integrated
- [ ] Barq branding integrated into the system image
- [ ] Boot and login branding
- [ ] First boot / welcome experience
- [ ] Barq Updater
- [ ] Installable ISO
- [ ] Hardware validation
- [ ] Public beta
- [ ] Barq OS 1.0 — Fajr

---

## Independence and upstream projects

Barq OS is an independent Linux project. It builds on open-source technologies and upstream projects including Fedora Atomic technologies, KDE Plasma, and BlueBuild.

References to upstream projects describe the technology Barq OS is built with and do not imply that Barq OS is an official edition or product of those upstream organizations.

---

## License

Repository code and configuration are licensed under the terms found in [`LICENSE`](./LICENSE). Third-party software included or referenced by Barq OS remains subject to its own licenses and redistribution terms.

---

## Barq OS

**Built for the way you play.**

*A modern Linux operating system designed for gaming, performance, and control.*

**برق — طاقة في حركة.**
