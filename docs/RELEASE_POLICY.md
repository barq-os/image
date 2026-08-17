# Barq OS — Release policy

## Channels

- `dev`: built from `main`; intended for developers and hardware testing.
- `beta`: planned promotion of an exact tested development digest.
- `stable`: planned promotion of the same digest after all release gates pass.

`latest` is a moving development tag, not a stable release contract.

## Promotion rule

Promote the exact OCI digest that passed testing. Do not rebuild different bits for beta or stable. Record the source commit, image digest, Fedora base version, test results, known issues, signature verification, and release decision.

## Required gates

1. BlueBuild succeeds with no critical warning.
2. The exact published digest verifies with `cosign.pub`.
3. Identity, host packages, boot, update, reboot and rollback checks pass.
4. Steam, Proton, Heroic, controllers, audio and Flatpak permissions are tested.
5. The hardware matrix records AMD and Intel results; NVIDIA requires its own supported image strategy.
6. The ISO, when introduced, passes UEFI, Secure Boot, installation, encryption, update and rollback tests.
7. Known issues and support boundaries are published.

## Version fields

Keep Fedora's base in `VERSION_ID` (`44` for the current recipe). Use `IMAGE_VERSION` for Barq's product version. Do not replace `VERSION_ID` with a Barq version.
