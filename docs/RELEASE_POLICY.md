# Barq OS — Release policy

## Channels

- `dev`: built from `main`; intended for developers and hardware testing.
- `beta`: planned promotion of an exact tested development digest.
- `stable`: planned promotion of the same digest after all release gates pass.

`latest` is a moving development tag, not a stable release contract.

## Promotion rule

Promote the exact OCI digest that passed testing. Do not rebuild different bits for beta or stable. Record the source commit, image digest, Fedora base version, test results, known issues, signature verification, and release decision.

## Required gates

1. Repository-quality checks pass for every tracked source class.
2. BlueBuild succeeds with no unresolved critical warning.
3. The exact published digest verifies with `cosign.pub`; image metadata and RPM inventory are preserved.
4. Identity, host packages, boot, update, reboot and rollback checks pass.
5. Steam, Proton, Heroic, controllers, audio and Flatpak permissions are tested.
6. The hardware matrix records AMD and Intel results; NVIDIA requires its own supported image strategy.
7. The ISO stays within the 6 GiB development budget and passes UEFI, Secure Boot, installation, encryption, update and rollback tests.
8. Known issues, security limitations, support window and recovery path are published.

Automated checks must not be described as proof of universal compatibility or zero vulnerabilities. A failed gate blocks promotion; branding or a successful container build cannot waive runtime evidence.

## Version fields

Keep Fedora's base in `VERSION_ID` (`44` for the current recipe). Use `IMAGE_VERSION` for Barq's product version. Do not replace `VERSION_ID` with a Barq version.
