# Contributing to Barq OS

Barq OS is in early development. Contributions should keep the project maintainable, reproducible, and focused on a reliable gaming-ready Linux desktop.

## Principles

- Keep the base image minimal and understandable.
- Prefer established upstream components over custom replacements unless Barq has a clear reason to diverge.
- Avoid unverified performance claims.
- Do not add automatic overclocking or unsafe hardware tuning.
- Keep gaming applications that benefit from independent updates as Flatpaks where practical.
- Keep host-level integration in the system image.
- Preserve Atomic update and rollback behavior.
- Treat Arabic and English as first-class interface languages.
- Follow the Barq visual identity: Electric Minimalism, restrained accents, and low visual noise.

## Changes

Before proposing a system change, document:

1. what problem it solves,
2. why it belongs in the OS image,
3. how it affects updates and rollback,
4. which hardware or desktop configurations it may affect,
5. how it was tested.

## Testing

At minimum, system-image changes should pass the BlueBuild workflow. Changes that affect gaming or hardware should also be tested on a real or virtual Barq deployment before being promoted toward a stable release.

## Naming

Use **Barq OS** consistently. Do not use `BARQOS`, `BarqOS`, `BARQ OS`, or `Barq Linux` as product names.

## Security

Do not commit secrets, private signing keys, access tokens, passwords, or private user data. The Cosign private signing key must remain outside the repository.
