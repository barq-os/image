# Barq OS documentation

This directory is the maintained technical and product reference for Barq OS. Primary documentation is written in English; approved localized strings remain in runtime metadata and the brand reference.

## System design

| Document | Purpose |
|---|---|
| [`ARCHITECTURE.md`](ARCHITECTURE.md) | Image layers, update model, identity order and hardware boundaries |
| [`TECHNICAL_AUDIT.md`](TECHNICAL_AUDIT.md) | Current research, file audit, decisions, evidence and remaining blockers |
| [`SECURITY_MODEL.md`](SECURITY_MODEL.md) | Threat boundaries, SELinux, Flatpak, portals, signing and limitations |
| [`VARIANTS.md`](VARIANTS.md) | KDE-first policy and the requirements for future desktop editions |

## Product integration

| Document | Purpose |
|---|---|
| [`IDENTITY.md`](IDENTITY.md) | Fedora 44-correct Barq identity from Plymouth through KInfoCenter |
| [`GAMING.md`](GAMING.md) | Gaming packages, Flatpak boundary and console-session gate |
| [`BRAND.md`](BRAND.md) | Naming, visual tokens, typography, voice and master-asset policy |

## Operations

| Document | Purpose |
|---|---|
| [`INSTALLATION.md`](INSTALLATION.md) | Atomic rebase, verification, rollback and ISO-candidate use |
| [`RELEASE_POLICY.md`](RELEASE_POLICY.md) | Channels, promotion rules and release gates |
| [`TEST_MATRIX.md`](TEST_MATRIX.md) | Automated, VM and hardware validation requirements |
| [`ROADMAP.md`](ROADMAP.md) | Gate-driven development work |

Repository contribution and vulnerability-reporting rules are maintained in [`../CONTRIBUTING.md`](../CONTRIBUTING.md) and [`../SECURITY.md`](../SECURITY.md).
