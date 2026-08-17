# Barq OS — Validation matrix

A successful CI build proves that the image can be assembled. It does not prove hardware, game, suspend, display, controller, installation or rollback compatibility.

| Gate | Minimum scope | Pass condition |
|---|---|---|
| Build | Complete recipe | BlueBuild succeeds; image-content checks run before signing |
| Published image | Exact OCI digest | Cosign verification, installed image check and `bootc container lint` pass |
| Identity | `hostnamectl`, KInfoCenter, TTY | Barq OS and the temporary Barq fallback logo are visible; `ID_LIKE=fedora` and `VERSION_ID=44` remain |
| Security baseline | Booted deployment | SELinux is Enforcing, Plasma uses Wayland and required portals are installed |
| Plymouth | Boot, shutdown, reboot, LUKS prompt, offline update | Barq theme renders; text/input remains usable; no silent black screen |
| Login | Plasma Login Manager on one and two displays | Barq wallpaper/colors render; login, session selection and power actions work |
| Plasma | Fresh user and existing user | New user gets Barq defaults; an existing user's chosen wallpaper/theme is not reset |
| Boot | UEFI; Secure Boot on/off | Reaches Plasma Login Manager and a Plasma Wayland session |
| Update | Digest N to N+1 | New deployment boots and user data remains intact |
| Rollback | After a tested update | Previous deployment boots without data loss |
| GPU | AMD and Intel baseline | Vulkan, suspend/resume and multi-monitor pass |
| NVIDIA | Separate supported image only | Driver, MOK/Secure Boot, Vulkan and updates pass |
| Gaming | DX11, DX12, Vulkan, OpenGL samples | Launch, controller, audio and frametime collection pass |
| Flatpak | Steam, Heroic, ProtonUp-Qt | Install, update, external storage and sandbox behavior documented |
| Controllers | Xbox, DualSense/DualShock, Nintendo where available | USB/Bluetooth, reconnect and resume pass |
| Arabic | Plasma, Discover, Barq surfaces | No clipping; correct RTL order and readable fonts |
| ISO | Exact signed digest; VM and physical device | Signature, boot, install, encryption, first update and rollback pass |

## Automation boundary

The build-time script validates the assembled filesystem. The published-image workflow validates a signed immutable digest in a container and runs `bootc container lint`. Neither check replaces a real UEFI boot, installer, update or rollback test.

## Hardware report

Record vendor/model, CPU, GPU, driver, firmware, display and connection, controller, image digest, test date, pass/fail result, logs, and a reproducible issue link.

Do not publish performance claims without the same hardware, firmware, power mode, game version, graphics settings, run method, sample count, FPS, 1% low and frametime data.
