# Contributing to Barq OS

Barq OS is in early development. Contributions must keep the image maintainable, reproducible, reversible, legally reviewable and honest about test coverage.

## Principles

- Prefer established upstream components over unnecessary replacements.
- Keep host integration in the image and suitable desktop applications in Flatpak.
- Preserve Atomic update and rollback behavior.
- Do not add automatic overclocking, unsafe tuning, unreviewed third-party repositories or unverified performance claims.
- Treat Arabic and English as first-class interface languages.
- Follow Electric Minimalism: restrained accents, clear hierarchy and low visual noise.
- Use **Barq OS** consistently; never `BARQOS`, `BarqOS`, `BARQ OS` or `Barq Linux`.

## Change requirements

Document the problem, why it belongs in the image, affected hardware, update/rollback impact, security and licensing impact, test method, results and rollback plan.

Run the source checks before opening a pull request:

```bash
bash tests/repository.sh
```

The repository-quality and BlueBuild PR workflows must pass. Hardware or gaming changes also require results using `docs/TEST_MATRIX.md`; CI alone is not proof of device or game compatibility. Do not mark VM or hardware gates as passed without the exact image digest and reproducible evidence.

New host packages require a reason they cannot be delivered safely as Flatpaks, a size and service review, Fedora repository provenance, update/rollback analysis and removal instructions. External GitHub Actions must use immutable full commit SHAs.

## Secrets

Never commit access tokens, passwords, personal logs, private signing keys or recovery material. `cosign.key`, `cosign.private` and GitHub's `SIGNING_SECRET` must remain outside the repository.
