# Barq OS — Technical audit

Audit date: 2026-08-18

Target: Barq OS 0.1 Development on Fedora Kinoite 44

## Executive decision

The repository is suitable for a signed development image and controlled installer candidate. It is not yet evidence-complete for public beta or stable release. The highest-value remaining work is VM and physical-device validation, not an unbounded package list, custom kernel, automatic tuning service or copied console stack.

The audit reviewed every tracked recipe, workflow, script, system file, desktop asset and document. Research prioritized primary upstream documentation, Fedora package/change records and source repositories for comparable Atomic gaming systems.

## Architecture decisions

| Area | Decision | Reason |
|---|---|---|
| Base | Stay on Fedora Kinoite 44 | Fedora 44 is stable; Fedora 45 was branched but not final on the audit date |
| Desktop | KDE Plasma on Wayland | Matches the product direction and Fedora's maintained Atomic KDE base |
| Login | Plasma Login Manager | Fedora 44's supported KDE login path; an SDDM theme would target the wrong baseline |
| Build | Split BlueBuild recipe | Keeps packages, files, identity and validation reviewable |
| Identity | Apply Barq identity late | Preserves Fedora-aware build behavior and keeps signing last |
| Updates | Atomic deployments and rollback | Reproducible system state without pretending mutable Fedora can be converted by installing one package |
| Applications | Flatpak for suitable desktop apps | Separates app updates from the host image and provides sandbox/portal boundaries |
| Gaming mode | Controller-first Steam launcher inside Plasma | Provides a useful 0.1 feature without claiming a complete DRM Gamescope session |
| Security | Fedora SELinux + Wayland + Flatpak/portals | Uses maintained platform controls instead of stacking unreviewed confinement systems |
| NVIDIA | Separate future recipe | Driver and Secure Boot requirements need their own lifecycle and hardware evidence |
| Other desktops | Separate future images | Avoids duplicate portals, login managers, defaults and image bloat |

## Fedora and upstream status

Fedora's lifecycle and release schedule support keeping the development image on version 44 until Fedora 45 is final and Barq has completed an explicit migration build, runtime test and rollback test. `VERSION_ID=44` remains the technical Fedora version; `IMAGE_VERSION=0.1` is the Barq product version.

The audited workflows use current pinned releases for the selected toolchain:

| Component | Selected version | Pin policy |
|---|---:|---|
| BlueBuild GitHub Action | 1.12.0 | Full commit SHA |
| actions/checkout | 7.0.1 | Full commit SHA |
| actions/upload-artifact | 7.0.1 | Full commit SHA |
| Cosign installer | 4.1.2 | Full commit SHA |
| Cosign CLI | 3.1.3 | Explicit version |
| build-container-installer | Audited 2026-07-13 commit | Full commit SHA |

Fedora 44 provides the selected GameMode, MangoHud, Gamescope, Steam device rules and NTSYNC integration through its repositories. Barq intentionally follows Fedora updates instead of freezing arbitrary RPM versions in the recipe.

## Comparable project review

| Project | Useful lesson | What Barq does not copy |
|---|---|---|
| Bazzite | Extensive runtime tests and a complete session stack require significant hardware-specific integration | No wholesale package list, privileged switcher or handheld policy |
| secureblue | Strong repository hygiene, immutable Action pins and explicit security documentation | No blind hardening flags or policy that has not been tested against Barq workloads |
| Bluefin | Clear separation between image purpose and user applications | No developer-focused defaults unrelated to Barq |
| ChimeraOS | A console session is a coordinated compositor, client, audio, input and recovery system | No Arch manifest, custom kernel or appliance-only desktop model |
| Hatter | KDE icon themes need variant, coverage, licensing and installation review | No third-party visual identity, large icon-tree vendoring or destructive installer script |

No code or artwork from these projects was copied in this audit. Their designs informed test boundaries and maintenance decisions only.

## File audit and corrections

### Repository quality

The original validation covered Bash syntax, JSON, SVG, the desktop launcher and Action pins. The expanded validator now checks:

- UTF-8, LF line endings, final newlines and tab policy for every tracked source file;
- all JSON and SVG parsing;
- the Barq desktop entry, KInfoCenter, KConfig, PLM, color scheme and Plymouth metadata;
- BlueBuild document markers, indentation, `from-file` targets and module ordering;
- identity after initramfs generation, validation before signing and signing as the final module;
- immutable full-SHA external Actions;
- the committed wallpaper's PNG signature and exact 3840×2160 dimensions;
- required QML imports/tokens and balanced braces;
- required Plymouth prompt, progress, update and message callbacks;
- absence of old distribution names and invalid Barq spellings on installed user-facing surfaces;
- isolated launcher behavior when Flatpak or Steam is missing and when Steam is ready.

A dedicated quality workflow runs these checks for every push and pull request, including documentation-only changes. The full BlueBuild workflow remains the authoritative recipe/schema and image assembly test.

### Image evidence

The published-image workflow now records the exact image reference, Docker image metadata, image size, `os-release` and a sorted RPM inventory. It then executes the installed Barq image check and `bootc container lint` against the digest-pinned image.

This inventory improves traceability but is not presented as a standards-compliant SBOM. SPDX or CycloneDX output remains a stable-release task after its generator and verification process are selected.

### Installer size and reproducibility

The ISO workflow disables the installer action's DNF cache, trading build time for fresh Fedora metadata and avoiding its tag-referenced transitive cache actions. It rejects an ISO above 6 GiB and emits metadata connecting the ISO to its source image digest and source commit. The ISO checksum and Sigstore bundle are verified before upload.

The size ceiling is a development guardrail, not a performance claim. Package removal requires runtime and recovery analysis; deleting apparently unused firmware, locales or drivers merely to reduce size can break supported hardware.

### Identity

The installed user-facing surfaces use Barq OS consistently: TTY, `os-release`, KInfoCenter, Plasma defaults, session splash, wallpaper, PLM and Plymouth. Fedora remains intentionally present in technical lineage and build configuration. Removing `ID_LIKE=fedora`, `VERSION_ID=44`, licenses or source attribution would reduce compatibility or violate project obligations rather than strengthen the brand.

The current wordmark is temporary because the attached brand specification did not include a licensed master Barq Mark vector. No generic lightning mark or Hatter artwork was fabricated.

## Security findings

The baseline correctly uses SELinux Enforcing, Wayland, Flatpak, KDE portals, exact-digest verification and Cosign. Barq does not silently grant broad Flatpak overrides, install a second mandatory-access-control system, add a SUID sandbox wrapper, or run an automatic privileged gaming optimizer.

Supply-chain improvements include a source-only quality workflow, least-privilege workflow permissions, full Action SHAs, non-persistent checkout credentials, Dependabot grouping, exact digest inputs, signed output and audit artifacts.

There is no credible process that proves “zero vulnerabilities.” Barq instead records known controls, evidence, residual risks and release blockers in [`SECURITY_MODEL.md`](SECURITY_MODEL.md).

## Performance findings

Barq's gaming host packages are reasonable integration components, but their presence is not a benchmark. No automatic overclocking, custom scheduler, custom kernel, indiscriminate sysctl profile or background optimizer was added. Performance claims require repeatable measurements with fixed hardware, firmware, power mode, game build, settings and sample method.

The controller-first launcher is intentionally small and exits into the existing Steam Flatpak. A full Gamescope DRM session is deferred to a separate hardware-gated image because it adds GPU, audio, display-manager, polkit and recovery complexity.

## Evidence levels and remaining blockers

| Evidence level | Automated now | Remaining work |
|---|---|---|
| Source | Format, policy, launcher behavior and static desktop validation | Optional full QML/Plymouth parsers when reliable tooling is available |
| Build | BlueBuild schema/build and installed-image assertions | Monitor warnings across Fedora updates |
| Published image | Cosign, exact digest, RPM inventory, smoke test, `bootc lint` | Standards-format SBOM and vulnerability triage policy |
| Booted VM | Live validator is available | UEFI, LUKS, installer, update, rollback, PLM and graphics evidence |
| Physical hardware | Matrix is defined | AMD/Intel devices, controllers, audio, displays, suspend and VRR |
| Stable release | Policy is defined | Support window, beta promotion, recovery exercise and release notes |

The repository cannot honestly close VM or hardware rows from container CI. A signed ISO candidate is ready for those tests; failures must be recorded rather than hidden by branding.

## Primary references

- [Fedora release lifecycle](https://docs.fedoraproject.org/en-US/releases/lifecycle/)
- [Fedora Atomic updates and rollback](https://docs.fedoraproject.org/en-US/atomic-desktops/updates-upgrades-rollbacks/)
- [Fedora desktop release notes](https://docs.fedoraproject.org/en-US/fedora/latest/release-notes/desktop/)
- [BlueBuild split configuration](https://blue-build.org/how-to/multiple-files/)
- [BlueBuild files module](https://blue-build.org/reference/modules/files/)
- [BlueBuild initramfs module](https://blue-build.org/reference/modules/initramfs/)
- [BlueBuild os-release module](https://blue-build.org/reference/modules/os-release/)
- [KDE KInfoCenter branding](https://develop.kde.org/docs/administration/kinfocenter/)
- [KDE Plasma 6 look-and-feel structure](https://develop.kde.org/docs/plasma/theme/theme-porting-to-plasma6/)
- [Plasma Login Manager source](https://github.com/KDE/plasma-login-manager)
- [Flatpak sandbox permissions](https://docs.flatpak.org/en/latest/sandbox-permissions.html)
- [GitHub Actions secure use](https://docs.github.com/en/actions/reference/security/secure-use)
- [Cosign verification](https://docs.sigstore.dev/cosign/verifying/verify/)
