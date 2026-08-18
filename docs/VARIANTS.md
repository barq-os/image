# Barq OS — Desktop variants

## Current edition

KDE Plasma is the only supported Barq OS 0.1 desktop. Its recipe, login manager, KConfig defaults, identity, tests and artwork form one coherent product surface.

Shipping multiple desktop environments in one generic image would duplicate applications, settings daemons and portals, increase installer size, complicate default selection and weaken visual QA. Barq therefore does not install a second desktop into the KDE image.

## Future edition policy

A future GNOME or other desktop edition must use a separate recipe and image name, for example `barq-gnome`, while sharing reviewed common modules for fonts, gaming packages, signing and non-desktop identity.

Each edition requires its own:

- maintained upstream Atomic base;
- display/login-manager integration;
- portal implementation and Flatpak tests;
- first-login and accessibility behavior;
- look-and-feel package and master-asset exports;
- image, ISO and hardware matrix;
- update and rollback testing across edition releases;
- documented support owner.

Desktop-specific files must live in dedicated modules instead of conditional scripts spread through the common recipe. Stable channels may be announced only after the edition independently passes the release gates.

## Shared identity fields

Every official edition uses `ID=barq`, `ID_LIKE=fedora`, the Fedora base `VERSION_ID`, `IMAGE_ID=barq`, and the same product naming rules. `VARIANT` and `VARIANT_ID` identify the desktop, such as `KDE Plasma` and `barq-kde`.
