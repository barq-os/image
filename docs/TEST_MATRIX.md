# Barq OS — Validation matrix

A successful CI build proves that the image can be assembled. It does not prove hardware, game, suspend, display, controller, installation, or rollback compatibility.

| Gate | Minimum scope | Pass condition |
|---|---|---|
| Build | Complete recipe | BlueBuild succeeds and the published digest verifies |
| Identity | `hostnamectl`, KInfoCenter, TTY | Barq OS is visible; `ID_LIKE=fedora` and `VERSION_ID=44` remain |
| Boot | UEFI; Secure Boot on/off | Reaches Plasma Login Manager and a Wayland session |
| Update | Digest N to N+1 | New deployment boots and user data remains intact |
| Rollback | After a tested update | Previous deployment boots without data loss |
| GPU | AMD and Intel baseline | Vulkan, suspend/resume and multi-monitor pass |
| NVIDIA | Separate supported image only | Driver, MOK/Secure Boot, Vulkan and updates pass |
| Gaming | DX11, DX12, Vulkan, OpenGL samples | Launch, controller, audio and frametime collection pass |
| Flatpak | Steam, Heroic, ProtonUp-Qt | Install, update, external storage and sandbox behavior documented |
| Controllers | Xbox, DualSense/DualShock, Nintendo where available | USB/Bluetooth, reconnect and resume pass |
| Arabic | Plasma, Discover, Barq surfaces | No clipping; correct RTL order and readable fonts |
| ISO | VM and physical device | Boot, install, encryption, first update and rollback pass |

## Hardware report

Record vendor/model, CPU, GPU, driver, firmware, display and connection, controller, image digest, test date, pass/fail result, logs, and a reproducible issue link.

Do not publish performance claims without the same hardware, firmware, power mode, game version, graphics settings, run method, sample count, FPS, 1% low and frametime data.
