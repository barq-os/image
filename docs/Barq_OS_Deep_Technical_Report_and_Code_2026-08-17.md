# Barq OS deep technical report and code audit

Date: 2026-08-17
Scope: Fedora 44, KDE Plasma, BlueBuild, Atomic updates, gaming, security,
branding, CI, image publication and development ISO readiness.

## Executive decision

Barq OS 0.1 Development is suitable for a controlled development-image and ISO
candidate, not for a stable public release. The repository now has a coherent
Fedora 44 identity, pre-signing image validation, exact-digest verification,
candidate ISO automation and an explicit hardware/runtime gate. The remaining
critical evidence is an actual VM installation plus physical AMD/Intel testing,
not more unreviewed packages or tuning.

## Audited architecture

| Layer | Selected implementation | Audit result |
|---|---|---|
| Base | Fedora Kinoite 44 bootable container | Keep; preserves Fedora hardware and update integration |
| Build | BlueBuild recipe split with `from-file` | Keep; identity and validation run late, signing runs last |
| Desktop | KDE Plasma Wayland | Keep; no X11-first fallback or custom compositor fork |
| Login | Plasma Login Manager | Correct for current Fedora 44; do not ship an SDDM theme under another name |
| Identity | BlueBuild `os-release` module | Keep `VERSION_ID=44` and `ID_LIKE=fedora`; Barq version is `IMAGE_VERSION=0.1` |
| Updates | rpm-ostree/bootc deployment model | Keep rollback behavior; do not claim mutable Fedora can be converted by installing rpm-ostree |
| Apps | User-scoped Flathub | Keep app/image lifecycle separate; document sandbox boundaries |
| Signing | Cosign plus exact OCI digests | Keep; OCI signature and UEFI Secure Boot are separate controls |
| Installer | Exact-digest ISO candidate workflow | Keep as a candidate until boot/install/update/rollback gates pass |

## Current upstream and Fedora versions

Versions below were verified from primary project releases or Fedora package
pages on the report date. Fedora image packages still follow the exact Fedora 44
snapshot resolved during each reproducible image build.

| Component | Current checked version | Barq policy |
|---|---:|---|
| BlueBuild CLI | 0.9.37 | Supplied and verified by the pinned BlueBuild Action |
| BlueBuild GitHub Action | 1.12.0 | Pinned to commit `836161eb076426a451e6a0054f722b1153b8b3ad` |
| build-container-installer | 1.5.0 | Pinned to commit `bed71f841c250650a70f1ed8315ba92da1591ba6` |
| actions/checkout | 7.0.1 | Pinned to commit `3d3c42e5aac5ba805825da76410c181273ba90b1` |
| actions/upload-artifact | 7.0.1 | Pinned to commit `043fb46d1a93c77aae656e7c1c64a875d1fc6a0a` |
| cosign-installer | 4.1.2 | Pinned to commit `6f9f17788090df1f26f669e9d70d6ae9567deba6` |
| Cosign | 3.1.3 | Explicitly selected in both verification/ISO workflows |
| Plasma Login Manager on Fedora 44 | 6.7.4 | Fedora update; Barq uses supported wallpaper/KConfig integration |
| GameMode on Fedora 44 | 1.8.2-4.fc44 | Installed from Fedora; no automatic overclock profile |
| Gamescope on Fedora 44 | 3.16.25-1.fc44 | Installed for nested use; full DRM session remains gated |
| MangoHud on Fedora 44 | 0.8.3~rc1-2.fc44 | Host package; Flatpak needs its matching runtime extension |
| MangoHud Flatpak extension | 0.8.4 / runtime 25.08 | Install only with a branch matching Steam's runtime |
| Steam Flatpak runtime | Freedesktop 25.08 | Community Flatpak; permissions are reviewed separately |
| Proton upstream | 11.0-1 | Steam-managed, not baked into the host image |
| GE-Proton upstream | GE-Proton11-5 | ProtonUp-Qt-managed, not forced globally |

## Hatter audit

The requested `Mibea/Hatter` repository is an icon theme, not a Linux image,
gaming stack or KDE shell. Its own README describes a rounded-square theme built
primarily around GNOME/Adwaita, with separate KDE light/dark variants.

Audit findings:

- repository size is roughly 600 MiB;
- main is active but has no GitHub releases or version tags;
- license is GPL-3.0;
- the installer copies all variants and first recursively removes existing
  Hatter directories from the selected icon destination;
- its visual goal is application-icon uniformity, not Barq's licensed master
  mark or the complete Electric Minimalism system identity.

Decision: do not vendor or execute Hatter in Barq 0.1. Doing so would bloat the
image, weaken reproducibility, introduce a second licensing boundary and make a
third-party visual system look like Barq artwork. If it is evaluated later, use
a pinned upstream commit, package one KDE variant as a clearly separate GPL-3.0
component, preserve authorship/license files, and run icon coverage/accessibility
QA. No Hatter code or artwork was copied by this change.

## Gaming-mode research

Bazzite demonstrates that a console-style session is a complete subsystem. Its
current source combines Gamescope session packages, Steam session control,
polkit actions, GPU/device logic, desktop/game switching and many hardware
paths. ChimeraOS `gamescope-session` likewise states that its common project
does not provide a complete user session by itself; a client-specific session
such as Steam is also required.

Real issue reports also show why a generic switch must not be added blindly:
session regressions, HDMI audio changes, capture/overlay limitations and
GPU-specific Gamescope crashes have all occurred in mature distributions.

For the 0.1 trial, Barq therefore adds an original, minimal `Barq Gaming`
launcher that opens Steam's controller-first UI inside the existing Plasma
Wayland session. This is reversible and does not need privileged helpers. A
future console image remains a separate hardware-tested deliverable.

## Security audit

The baseline is Fedora SELinux Enforcing plus Wayland, Flatpak and KDE portals.
That is meaningful defense in depth, but it is not equivalent to iOS:

- Steam's current Flatpak manifest requests network, X11/Wayland, audio,
  external media, UDisks2 and `--device=all` for gaming compatibility;
- Flatpak applications can request broad static permissions;
- native host RPMs are not automatically sandboxed like Flatpaks;
- all containers and Flatpaks still share the host kernel.

Implemented policy:

- validate SELinux configuration and live Enforcing state;
- require Wayland and KDE portal packages;
- install Flatseal so permissions are inspectable;
- do not apply global `flatpak override` rules;
- do not import experimental SELinux policy, SUID sandboxes or blanket systemd
  hardening from another distribution without workload tests;
- reserve virtual machines for hostile or untrusted code.

## Repository and supply-chain audit

The repository test now verifies:

- Bash syntax for project scripts;
- required executable bits;
- absence of unresolved merge markers;
- every recipe `from-file` target exists;
- JSON and SVG syntax;
- every external GitHub Action is pinned to a full 40-character commit SHA;
- whitespace/error checks through `git diff --check`.

The BlueBuild job then assembles the complete image, runs the installed image
validator before signing, verifies installation compatibility and publishes
only on non-PR events. The published-image workflow accepts an exact digest,
verifies Cosign, executes the validator in that immutable image and runs
`bootc container lint`.

## Release blockers and required evidence

| Priority | Missing evidence | Completion rule |
|---|---|---|
| P0 | Published unified `main` digest | Push build succeeds, digest is recorded and Cosign verification passes |
| P0 | VM installer test | UEFI boot, install, encryption, first boot, first update and rollback pass |
| P0 | Recovery | Previous deployment boots after an intentionally rejected candidate |
| P1 | AMD and Intel hardware | Vulkan, controller, audio, suspend, VRR and multi-monitor reports pass |
| P1 | Flatpak gaming boundary | Steam ↔ GameMode and MangoHud 25.08 extension results are recorded |
| P1 | Arabic/RTL | PLM, Plasma, About System and documentation have no clipping/order defects |
| P2 | NVIDIA | Separate image, driver and Secure Boot/MOK design; never silently inject into generic image |
| P2 | Master Barq Mark | Licensed vector supplied and replaces the temporary typographic fallback in place |
| Deferred | Full console session | Separate image/session with hardware matrix and controller-only recovery |

## Verification commands

Repository checks:

```bash
bash tests/repository.sh
```

Booted deployment checks:

```bash
rpm-ostree status
sudo /usr/libexec/barq-os/image-smoke-test --live
flatpak info --show-permissions com.valvesoftware.Steam
```

Exact published image check:

```bash
cosign verify --key cosign.pub \
  ghcr.io/barq-os/barq@sha256:IMAGE_DIGEST
```

## Primary sources

- BlueBuild modules: <https://github.com/blue-build/modules>
- BlueBuild GitHub Action: <https://github.com/blue-build/github-action/releases/tag/v1.12.0>
- Fedora Plasma Login Manager package: <https://packages.fedoraproject.org/pkgs/plasma-login-manager/plasma-login-manager/>
- KDE Plasma themes and plugins: <https://develop.kde.org/docs/plasma/>
- KDE KInfoCenter branding: <https://develop.kde.org/docs/administration/kinfocenter/>
- Fedora GameMode package: <https://packages.fedoraproject.org/pkgs/gamemode/gamemode/>
- Fedora Gamescope package: <https://packages.fedoraproject.org/pkgs/gamescope/gamescope/>
- Fedora MangoHud package: <https://packages.fedoraproject.org/pkgs/mangohud/mangohud/>
- Steam Flatpak manifest: <https://github.com/flathub/com.valvesoftware.Steam>
- MangoHud Flatpak extension: <https://github.com/flathub/org.freedesktop.Platform.VulkanLayer.MangoHud>
- Flatpak sandbox permissions: <https://docs.flatpak.org/en/latest/sandbox-permissions.html>
- Bazzite source: <https://github.com/ublue-os/bazzite>
- ChimeraOS Gamescope session: <https://github.com/ChimeraOS/gamescope-session>
- Hatter source and GPL-3.0 license: <https://github.com/Mibea/Hatter>
- secureblue source (research reference only): <https://github.com/secureblue/secureblue>
