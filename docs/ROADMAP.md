# Barq OS — Development roadmap

The roadmap is gate-driven. Dates never override build, hardware, rollback, security or installer blockers.

## 0.1 — Hardening

- [x] Fedora Kinoite 44 BlueBuild base
- [x] Signed development image on GHCR
- [x] Split recipe and late identity module
- [x] Pin BlueBuild Action v1.12.0 by full commit SHA
- [x] Verify the downloaded BlueBuild CLI
- [x] Add push retry and PR-safe publish behavior
- [x] Add security, release, installation and validation policy

## 0.2 — Gaming foundation

- [x] GameMode, MangoHud and Gamescope
- [x] Steam, Heroic and ProtonUp-Qt
- [x] `steam-devices` host rules
- [x] Fedora 44 `ntsync-autoload` integration
- [ ] Validate Steam Flatpak ↔ GameMode D-Bus behavior
- [ ] Select and test the matching MangoHud Flatpak runtime extension
- [ ] Test external Steam libraries and Flatpak permissions
- [ ] Publish a small supported/unsupported game matrix including anti-cheat limits

## 0.3 — Validation

- [ ] VM boot, update and rollback
- [ ] Two AMD/Intel physical-device reports
- [ ] Controller, audio and suspend/resume results
- [ ] Multi-monitor and VRR results
- [ ] Arabic and English UI QA

## 0.4 — Identity

- [ ] Add the licensed master Barq Mark and variants
- [ ] Verify KInfoCenter, TTY, Plasma Login Manager and Plasma Setup
- [ ] Add wallpaper, color scheme and restrained Plasma defaults
- [ ] Add Plymouth only after boot and rollback testing

## 0.5 — Installation media

- [ ] Generate ISO from an exact signed development digest
- [ ] Test UEFI and Secure Boot on/off
- [ ] Test partitioning, encryption and Plasma Setup
- [ ] Test first update, rollback and reinstall
- [ ] Publish checksum, signature, requirements and recovery documentation

## 0.6 — NVIDIA

- [ ] Select a supported base and separate `barq-nvidia` recipe
- [ ] Define driver, kernel and Secure Boot/MOK policy
- [ ] Test updates, rollback, Wayland, Vulkan, suspend and multi-monitor

## 0.7 — First-party experience

- [ ] Barq Welcome that complements Plasma Setup
- [ ] Barq Control using Kirigami and a narrow privileged helper
- [ ] Reassess Barq Updater only after documenting a concrete Discover gap

## 0.8 — Channels

- [ ] Promote exact digests through dev → beta → stable
- [ ] Publish known issues and hardware results
- [ ] Test upgrade and rollback across channel transitions

## 1.0 — Fajr / فجر

- [ ] No open release blockers
- [ ] Supported signed stable image
- [ ] Supported installer ISO
- [ ] Published support window, release notes and recovery path

## Deferred experiments

Custom kernels, automatic overclocking, AI optimizers, Plasma Union as a foundation, console mode and automatic per-game tuning are not required for 1.0.
