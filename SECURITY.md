# Security Policy

Barq OS is currently a development image. It is not yet a stable security-support channel.

## Reporting a vulnerability

Do not publish exploitable details, signing material, tokens, private logs, or personal data in a public issue. Use GitHub private vulnerability reporting for this repository when available. Public issues are appropriate for non-sensitive defects only.

Include the affected image tag or digest, reproduction conditions, expected impact, and the smallest safe diagnostic sample.

## Image verification

Verify a published image with the repository public key and an exact digest:

```bash
cosign verify --key cosign.pub \
  ghcr.io/barq-os/barq@sha256:IMAGE_DIGEST
```

A valid Cosign signature authenticates the published OCI image. It does not by itself verify the device's UEFI Secure Boot chain or third-party kernel modules.

## Signing material

The private Cosign key must never be committed. Rotation and recovery require updating the GitHub Actions secret, publishing the replacement public key, rebuilding the image, and documenting the trust transition.
