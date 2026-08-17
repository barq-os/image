# Barq OS — Development Roadmap

This roadmap defines the order of work for Barq OS. It is intentionally conservative: the project should become a reliable operating system before adding complex Barq-specific gaming automation.

## 0.1 — Base image

- [x] Create `barq-os` GitHub organization
- [x] Create core `image` repository
- [x] Build from Fedora Kinoite / KDE Plasma
- [x] Configure Cosign signing
- [x] Publish the image to GHCR
- [x] Replace template documentation with Barq documentation

## 0.2 — Gaming foundation

- [x] Add GameMode
- [x] Add MangoHud
- [x] Add Gamescope
- [x] Configure Steam
- [x] Configure Heroic Games Launcher
- [x] Configure ProtonUp-Qt
- [ ] Validate a successful image build
- [ ] Test Steam + Proton on hardware
- [ ] Test Heroic
- [ ] Test controllers

## 0.3 — System identity

- [x] Set Barq OS metadata in `os-release`
- [ ] Verify KDE About/System Information presentation
- [ ] Remove or replace remaining upstream branding where appropriate and legally permitted
- [ ] Add Barq system information assets

## 0.4 — Visual identity

- [ ] Add the master Barq Mark asset
- [ ] Add Barq wallpaper set
- [ ] Create KDE color scheme from Electric Minimalism tokens
- [ ] Create Plasma theme defaults
- [ ] Create SDDM login experience
- [ ] Create Plymouth boot experience

## 0.5 — Hardware validation

- [ ] AMD GPU test matrix
- [ ] Intel GPU test matrix
- [ ] NVIDIA strategy and test image
- [ ] Wi-Fi and Bluetooth testing
- [ ] Audio testing
- [ ] Multi-monitor testing
- [ ] VRR testing where supported
- [ ] Suspend/resume testing
- [ ] Controller testing

## 0.6 — First-party experience

- [ ] Barq Welcome
- [ ] Barq Control
- [ ] Barq Updater
- [ ] Arabic + RTL QA
- [ ] English QA

## 0.7 — Installation media

- [ ] Generate a bootable Barq ISO
- [ ] Test clean installation in a VM
- [ ] Test clean installation on physical hardware
- [ ] Document system requirements
- [ ] Document installation and recovery

## 0.8 — Update channels

- [ ] Development channel
- [ ] Beta channel
- [ ] Stable channel
- [ ] Test upgrade and rollback paths
- [ ] Publish release notes and known issues

## 0.9 — Public beta

- [ ] Feature freeze
- [ ] Bug triage
- [ ] Hardware community testing
- [ ] Security and licensing review
- [ ] Website download flow
- [ ] Documentation review

## 1.0 — Fajr / فجر

- [ ] Release candidate
- [ ] Stable signed image
- [ ] Stable installer ISO
- [ ] Barq Updater ready
- [ ] Release notes
- [ ] Public documentation
- [ ] Launch Barq OS 1.0 — Fajr

## Later ideas

These are explicitly not required for the first release:

- automatic hardware/game optimization engine
- advanced gaming session / console mode
- per-game performance profiles
- dynamic upscaling automation
- custom kernel experiments

They should only be considered after the core OS is stable and maintainable.
