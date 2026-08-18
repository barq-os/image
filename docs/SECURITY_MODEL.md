# Barq OS — Security model

## Scope

Barq OS combines an image-based host, SELinux, Wayland, Flatpak, desktop portals, signed publication and rollback. These layers reduce different risks; none is a promise that the system has zero vulnerabilities.

The current 0.1 channel is a development system. Security support, incident-response times and a stable update channel must be defined before a stable release.

## Trust boundaries

| Boundary | Current control | Important limitation |
|---|---|---|
| Published system image | Cosign signature over an exact OCI digest | Does not verify local UEFI firmware or third-party modules |
| Host filesystem | Atomic image and deployment rollback | Root and kernel compromise remain high impact |
| Mandatory access control | Fedora SELinux policy in Enforcing mode | Policy defects and kernel vulnerabilities are still possible |
| Graphical clients | Plasma Wayland session | XWayland clients retain weaker isolation from other XWayland clients |
| Desktop applications | User-scoped Flatpaks and Bubblewrap sandboxes | An application can request broad static permissions |
| User-mediated access | KDE implementation of xdg-desktop-portal | Portals protect only operations routed through them |
| Services | Upstream systemd units and Fedora policy | New privileged services require separate hardening review |
| Untrusted code | A dedicated VM is recommended | Containers and Flatpaks share the host kernel |

## Desktop application policy

Desktop applications should be Flatpaks when the packaging and sandbox are suitable. Barq does not apply blanket `--filesystem=home`, `--filesystem=host`, session-bus or device overrides. Users can inspect application permissions with:

```bash
flatpak info --show-permissions APP_ID
```

Flatseal is installed as a review interface, not as an automatic permission optimizer. Selected files should be shared through the File Chooser portal where supported. Steam necessarily needs broader device and gaming access than a document viewer, so its permissions must be assessed against its function rather than compared mechanically.

Native RPM programs are not automatically sandboxed like Flatpaks. Adding Firejail, AppArmor or arbitrary SELinux policy does not make every native application safe and can create a second, poorly maintained policy system. Barq uses Fedora's SELinux baseline and requires an explicit threat model before adding a new confinement mechanism.

## Services and privileged helpers

Barq 0.1 does not add a privileged gaming optimizer, automatic overclock service or broad polkit action. A future Barq Control helper must expose a narrow API, validate all inputs, use the minimum capabilities, ship an explicit polkit policy, and pass `systemd-analyze security` plus an SELinux review.

## Supply-chain controls

- External GitHub Actions are pinned to immutable full commit SHAs.
- Dependabot monitors GitHub Action references.
- Checkout credentials are not persisted.
- Workflows declare minimal GitHub token permissions.
- The BlueBuild image is signed only after installed-image validation.
- Published-image verification records the exact digest, image metadata and sorted RPM inventory.
- Installer candidates are generated from exact signed digests and are signed as blobs using Cosign's standardized bundle format.
- Private signing keys and tokens are never committed.

The RPM inventory is audit evidence, not yet a standards-format SBOM. A stable release should add and validate SPDX or CycloneDX output without replacing Fedora security advisories or vulnerability triage.

## Update and recovery

Atomic deployments make the selected system version observable and allow rollback. Rollback is a recovery mechanism, not a security fix: a vulnerable previous deployment can remain vulnerable. Security incidents may require key rotation, image rebuilds, package updates and explicit revocation or migration guidance.

## Hostile code

Do not treat Flatpak, Distrobox, Toolbx, Podman or Firejail as a safe boundary for deliberately malicious kernel-facing code. Use a disposable KVM virtual machine or separate physical device, disable shared folders and credentials, and restrict networking as required by the experiment.

## Release blockers

Before beta, Barq needs documented vulnerability intake, image-update monitoring, key rotation rehearsal, Secure Boot installation evidence, Flatpak permission review, and VM/physical-device results. See [`TEST_MATRIX.md`](TEST_MATRIX.md).

## Primary references

- [Fedora SELinux fundamentals](https://docs.fedoraproject.org/en-US/quick-docs/selinux-getting-started/)
- [Flatpak sandbox permissions](https://docs.flatpak.org/en/latest/sandbox-permissions.html)
- [Desktop portal configuration](https://flatpak.github.io/xdg-desktop-portal/docs/portals.conf.html)
- [File Chooser portal](https://flatpak.github.io/xdg-desktop-portal/docs/doc-org.freedesktop.portal.FileChooser.html)
- [GitHub Actions secure use](https://docs.github.com/en/actions/reference/security/secure-use)
- [Cosign verification](https://docs.sigstore.dev/cosign/verifying/verify/)
