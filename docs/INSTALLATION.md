# Barq OS — Installation and testing

Barq OS is an early development image. Back up important data and prefer a virtual machine or non-critical test device.

## Compatibility requirement

Rebasing requires an existing Fedora Atomic Desktop deployment such as Fedora Kinoite. Before continuing, this command must succeed and show an OSTree deployment:

```bash
rpm-ostree status
```

Fedora KDE Plasma Desktop Edition installed with DNF is not an Atomic deployment. Installing the `rpm-ostree` package does not convert it and must not be used as a shortcut.

## Rebase from Fedora Atomic

First enter the unverified image so Barq's signing policy is installed:

```bash
sudo rpm-ostree rebase \
  ostree-unverified-registry:ghcr.io/barq-os/barq:latest
sudo systemctl reboot
```

After the first Barq boot, move to the signed reference:

```bash
sudo rpm-ostree rebase \
  ostree-image-signed:docker://ghcr.io/barq-os/barq:latest
sudo systemctl reboot
```

Confirm the deployment and run the installed live validation:

```bash
rpm-ostree status
sudo /usr/libexec/barq-os/image-smoke-test --live
```

The live check validates Barq identity, required host components, SELinux enforcing mode, Wayland and Plasma Login Manager. The image build also executes the non-live portion before signing.

## Rollback

If the new deployment does not boot correctly, select the previous deployment from the boot menu. From a working deployment, use:

```bash
sudo rpm-ostree rollback
sudo systemctl reboot
```

## ISO candidate workflow

The `installer ISO candidate` workflow accepts only an exact `sha256:` image digest. It first calls the published-image workflow, verifies the image with `cosign.pub`, executes the image checks and `bootc container lint`, then builds the ISO and produces:

- the installer ISO;
- the installer's generated checksum;
- a normalized SHA-256 file;
- a Cosign standardized bundle for the ISO signature;
- metadata recording the source image digest, source commit and file size.

The workflow rejects candidates larger than 6 GiB. Artifacts expire after 14 days and remain development candidates. Do not present an artifact as an official release until it passes the ISO, VM and physical-device gates in `TEST_MATRIX.md` and `RELEASE_POLICY.md`.

Verify a downloaded candidate before booting it:

```bash
sha256sum --check Barq-OS-0.1-Development-x86_64.iso.sha256
cosign verify-blob --key cosign.pub \
  --bundle Barq-OS-0.1-Development-x86_64.iso.sigstore.json \
  Barq-OS-0.1-Development-x86_64.iso
```
