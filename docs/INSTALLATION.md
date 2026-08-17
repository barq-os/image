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

Confirm the deployment and run the repository smoke test:

```bash
rpm-ostree status
bash tests/smoke.sh
```

## Rollback

If the new deployment does not boot correctly, select the previous deployment from the boot menu. From a working deployment, use:

```bash
sudo rpm-ostree rollback
sudo systemctl reboot
```

## ISO status

A supported Barq installer ISO has not been published yet. Do not present a locally generated ISO as an official release until it passes the release gates in `TEST_MATRIX.md` and `RELEASE_POLICY.md`.
