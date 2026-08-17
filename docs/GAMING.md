# Barq OS — Gaming integration

## Barq Gaming launcher

`Barq Gaming` opens Steam's controller-first interface without replacing or
ending the Plasma Wayland session. It is intentionally a low-risk desktop
launcher for the 0.1 development trial, not a claim that Barq already provides
a SteamOS-style DRM Gamescope session.

The launcher is installed at:

```text
/usr/share/applications/org.barq.Gaming.desktop
```

and executes:

```text
/usr/libexec/barq-os/open-gaming-interface
```

If the first-login Flatpak setup has not installed Steam yet, the launcher
shows an actionable error rather than attempting privileged installation.

## Host and Flatpak boundary

GameMode, MangoHud and Gamescope are host packages. Steam, Heroic and
ProtonUp-Qt are user Flatpaks. A host library is not automatically visible
inside a Flatpak sandbox, so each integration must be tested across that
boundary instead of being inferred from package presence.

The current Steam Flatpak uses the Freedesktop 25.08 runtime and requests broad
gaming-related permissions, including all devices and external media paths.
Flatseal is installed by default so users can inspect these permissions, but
Barq does not silently apply global Flatpak overrides.

For MangoHud inside the Steam Flatpak, install the extension matching Steam's
runtime branch and test it before enabling it globally:

```bash
runtime="$(flatpak info --user --show-runtime com.valvesoftware.Steam)"
branch="${runtime##*/}"
flatpak install --user flathub \
  "org.freedesktop.Platform.VulkanLayer.MangoHud//$branch"
```

The matching branch is important. Barq does not hard-code a runtime extension
into the host image because Steam can move to a new Freedesktop runtime between
image releases.

## Full console session gate

A standalone Gamescope session requires more than the `gamescope` RPM. Mature
implementations include a display-manager session, Steam session definition,
session switching, polkit policy, GPU/display selection, audio handling,
handheld quirks and recovery when Gamescope or Steam exits immediately.

Barq will not copy a distro-specific switching stack into the generic image.
A future `barq-deck` or HTPC image can add it only after:

1. AMD and Intel DRM-session boot tests;
2. NVIDIA strategy and Secure Boot policy;
3. HDMI/DisplayPort audio and capture tests;
4. VRR, HDR, multi-monitor and suspend/resume tests;
5. controller-only recovery back to Plasma;
6. a least-privilege review of every polkit action.

## Honest performance policy

Do not publish performance claims from package lists. Record the image digest,
hardware, firmware, power mode, game and build, graphics settings, run method,
sample count, average FPS, 1% low and frametime data.
