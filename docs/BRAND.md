# Barq OS — Brand reference

## Core

**Barq OS** is the official product name. **Barq** comes from **برق** — lightning.

> **Built for the way you play.**
>
> **مصمم لطريقتك في اللعب.**

> **Energy in motion.**
>
> **طاقة في حركة.**

Barq OS is fast, refined and powerful. Its pillars are Performance, Play, Freedom and Control.

## Electric Minimalism

Use deep neutral surfaces, precise geometry, clean typography, generous spacing, restrained electric accents and short purposeful motion. Avoid excessive RGB, glow, bloom, bouncing animation and visual noise.

| Token | Value | Role |
|---|---:|---|
| Barq Midnight | `#050814` | Primary dark background |
| Barq Surface | `#0B1220` | Cards and elevated surfaces |
| Barq Blue | `#1A7BFF` | Active state and primary accent |
| Electric Cyan | `#22D7FF` | Motion and secondary highlight |
| Ice | `#EAF2FF` | Text and icons on dark backgrounds |
| Pure White | `#FFFFFF` | High-emphasis neutral |

Target approximately 70% neutral/dark surfaces, 20% white/ice/neutrals and 10% Barq Blue/Electric Cyan.

## Typography

- Latin UI/display: Inter
- Arabic UI/display: Noto Sans Arabic
- Technical/monospace: JetBrains Mono

The system image installs the Fedora-packaged variants. Verify font metrics, Arabic shaping and RTL layouts before changing Plasma defaults globally.

## Naming

Always write **Barq OS**. Avoid `BARQOS`, `BarqOS`, `BARQ OS` and `Barq Linux`. The Arabic form **برق** is a secondary identity element; it need not appear beside the English name on every screen.

Do not lead the product with “Arabic Gaming Linux.” Arabic roots should appear through naming, language quality, RTL support and release names while the product remains global.

## Master asset rule

Do not invent a generic lightning symbol. The repository must receive the original Barq Mark as a licensed master vector, plus monochrome variants, clear-space rules and export guidance, before system logos, boot graphics or a press kit are added.

The current development image uses a clearly identified typographic `Barq OS` fallback for `os-release`, KInfoCenter, Plasma splash and Plymouth. The abstract “Energy in motion” wallpaper uses only the approved color and motion language; it is not the Barq Mark. Replace the fallback asset in place when the licensed master vector arrives—do not add a second competing symbol.

## Fedora 44 system surfaces

| Surface | Barq implementation | Constraint |
|---|---|---|
| Plymouth | Midnight-to-Surface field, `Barq OS` wordmark, blue progress and readable prompts | Must retain disk-encryption, update and error prompts |
| Plasma Login Manager | Barq wallpaper and global Barq Dark/Inter defaults | PLM has a fixed Breeze frontend; no fake SDDM/QML theme |
| Plasma | Barq Dark, Breeze controls, Barq wallpaper and short session splash | User choices override distro defaults |
| Lock screen | Same wallpaper and color family as PLM | Do not expose private notification content by default |
| About This System | `Barq OS Development`, Barq wordmark fallback and build metadata | Fedora remains visible only as technical lineage through `ID_LIKE`/`VERSION_ID` |

The current wallpaper source is SVG and the committed PNG is its deterministic 3840×2160 render. It follows the 70/20/10 balance with restrained blue/cyan motion bands and intentionally contains no generic lightning glyph.

## Voice

Prefer **Fast / Refined / Powerful**. Avoid inflated claims such as **Ultimate / Extreme / Game-changing**.
