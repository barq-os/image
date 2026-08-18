#!/usr/bin/env bash
set -Eeuo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

fail() {
  printf 'Repository validation failed: %s\n' "$1" >&2
  exit 1
}

find files/scripts files/system/usr/libexec tests -type f \
  \( -name '*.sh' -o -perm -u+x \) -print0 |
  sort -z |
  xargs -0 --no-run-if-empty bash -n

if command -v shellcheck >/dev/null 2>&1; then
  find files/scripts files/system/usr/libexec tests -type f \
    \( -name '*.sh' -o -perm -u+x \) -print0 |
    sort -z |
    xargs -0 --no-run-if-empty shellcheck
else
  printf 'NOTE: ShellCheck is not installed; Bash parser checks still ran.\n'
fi

for executable in \
  files/system/usr/libexec/barq-os/image-smoke-test \
  files/system/usr/libexec/barq-os/open-gaming-interface \
  tests/gaming-launcher.sh \
  tests/repository.sh \
  tests/smoke.sh; do
  [[ -x "$executable" ]] || fail "$executable must be executable"
done

if git grep -nE '^(<<<<<<<|=======|>>>>>>>)' -- . ':!tests/repository.sh'; then
  fail "unresolved merge markers found"
fi

bash tests/gaming-launcher.sh

python3 - <<'PY'
from __future__ import annotations

from pathlib import Path
import configparser
import json
import re
import struct
import subprocess
import sys
import xml.etree.ElementTree as ET

try:
    import yaml
except ImportError:
    yaml = None


def fail(message: str) -> None:
    print(f"Repository validation failed: {message}", file=sys.stderr)
    raise SystemExit(1)


def parse_ini(path: Path) -> configparser.ConfigParser:
    parser = configparser.ConfigParser(interpolation=None, strict=True)
    parser.optionxform = str
    try:
        with path.open(encoding="utf-8") as stream:
            parser.read_file(stream)
    except (configparser.Error, UnicodeDecodeError) as error:
        fail(f"{path}: invalid INI/KConfig data: {error}")
    return parser


tracked_output = subprocess.check_output(
    ["git", "ls-files", "-co", "--exclude-standard", "-z"]
)
tracked = sorted(
    Path(item.decode("utf-8"))
    for item in tracked_output.split(b"\0")
    if item
)

for path in tracked:
    if not path.is_file():
        continue
    data = path.read_bytes()
    if not data or b"\0" in data or path.suffix.lower() in {".png", ".jpg", ".jpeg"}:
        continue
    try:
        text = data.decode("utf-8")
    except UnicodeDecodeError as error:
        fail(f"{path}: source text is not valid UTF-8: {error}")
    if "\r" in text:
        fail(f"{path}: CRLF/CR line endings are not allowed")
    if not text.endswith("\n"):
        fail(f"{path}: missing final newline")
    if "\t" in text:
        fail(f"{path}: tab characters are not allowed in source text")
    for number, line in enumerate(text.splitlines(), 1):
        if line.endswith((" ", "\t")):
            fail(f"{path}:{number}: trailing whitespace")

for path in sorted(Path(".").rglob("*.json")):
    try:
        with path.open(encoding="utf-8") as stream:
            json.load(stream)
    except (json.JSONDecodeError, UnicodeDecodeError) as error:
        fail(f"{path}: invalid JSON: {error}")

if yaml is None:
    print("NOTE: PyYAML is not installed; targeted YAML policy checks still run.")
else:
    for path in sorted(Path(".").rglob("*.yml")):
        try:
            with path.open(encoding="utf-8") as stream:
                yaml.safe_load(stream)
        except (yaml.YAMLError, UnicodeDecodeError) as error:
            fail(f"{path}: invalid YAML: {error}")

for path in sorted(Path(".").rglob("*.svg")):
    try:
        ET.parse(path)
    except ET.ParseError as error:
        fail(f"{path}: invalid SVG/XML: {error}")

markdown_link = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
for path in sorted(Path(".").rglob("*.md")):
    source = path.read_text(encoding="utf-8")
    for link in markdown_link.findall(source):
        if link.startswith(("http://", "https://", "mailto:", "#")):
            continue
        target_text = link.split("#", 1)[0]
        if not target_text:
            continue
        target = (path.parent / target_text).resolve()
        if not target.exists():
            fail(f"{path}: broken relative link {link!r}")

documentation_index = Path("docs/README.md").read_text(encoding="utf-8")
for path in sorted(Path("docs").glob("*.md")):
    if path.name == "README.md":
        continue
    if f"({path.name})" not in documentation_index:
        fail(f"docs/README.md: missing documentation entry for {path.name}")

ini_paths = [
    Path("files/system/etc/xdg/kcm-about-distrorc"),
    Path("files/system/etc/xdg/kdeglobals"),
    Path("files/system/etc/xdg/kscreenlockerrc"),
    Path("files/system/usr/lib/plasmalogin/defaults.conf"),
    Path("files/system/usr/share/applications/org.barq.Gaming.desktop"),
    Path("files/system/usr/share/color-schemes/BarqDark.colors"),
    Path("files/system/usr/share/plymouth/themes/barq/barq.plymouth"),
]
parsed = {path: parse_ini(path) for path in ini_paths}

desktop = Path("files/system/usr/share/applications/org.barq.Gaming.desktop")
entry = parsed[desktop]["Desktop Entry"]
required_desktop = {
    "Type": "Application",
    "Name": "Barq Gaming",
    "Exec": "/usr/libexec/barq-os/open-gaming-interface",
    "Icon": "barq-os",
    "Terminal": "false",
}
for key, expected in required_desktop.items():
    if entry.get(key) != expected:
        fail(f"{desktop}: expected {key}={expected!r}")

about = Path("files/system/etc/xdg/kcm-about-distrorc")
about_general = parsed[about]["General"]
for key, expected in {
    "LogoPath": "barq-os",
    "Name": "Barq OS",
    "Version": "0.1 Development",
    "Variant": "KDE Plasma",
    "ShowBuild": "true",
}.items():
    if about_general.get(key) != expected:
        fail(f"{about}: expected {key}={expected!r}")

plm = Path("files/system/usr/lib/plasmalogin/defaults.conf")
plm_general = parsed[plm]["Greeter"]
if plm_general.get("WallpaperPluginId") != "org.kde.image":
    fail(f"{plm}: unsupported wallpaper plugin")
plm_wallpaper = parsed[plm]["Greeter][Wallpaper][org.kde.image][General"]
if plm_wallpaper.get("Image") != "file:///usr/share/wallpapers/Barq/":
    fail(f"{plm}: unexpected wallpaper path")

plymouth = Path("files/system/usr/share/plymouth/themes/barq/barq.plymouth")
if parsed[plymouth]["Plymouth Theme"].get("ModuleName") != "script":
    fail(f"{plymouth}: Barq must use the Plymouth script module")

for path in sorted(Path("recipes").rglob("*.yml")):
    source = path.read_text(encoding="utf-8")
    if not source.startswith("---\n"):
        fail(f"{path}: BlueBuild YAML must start with a document marker")
    for number, line in enumerate(source.splitlines(), 1):
        if not line or line.lstrip().startswith("#"):
            continue
        indentation = len(line) - len(line.lstrip(" "))
        if indentation % 2:
            fail(f"{path}:{number}: YAML indentation must use two-space levels")

recipe = Path("recipes/recipe.yml")
recipe_source = recipe.read_text(encoding="utf-8")
required_recipe_fields = [
    "base-image: ghcr.io/blue-build/base-images/fedora-kinoite",
    "image-version: 44",
    "- type: initramfs",
    "- type: signing",
]
for field in required_recipe_fields:
    if field not in recipe_source:
        fail(f"{recipe}: missing {field}")

module_lines = [
    line.strip()
    for line in recipe_source.splitlines()
    if line.startswith("  - ")
]
if module_lines[-1] != "- type: signing":
    fail(f"{recipe}: signing must be the final module")
if module_lines.count("- type: signing") != 1:
    fail(f"{recipe}: signing must appear exactly once")

required_order = [
    "- from-file: common/identity-setup.yml",
    "- type: initramfs",
    "- from-file: common/identity.yml",
    "- from-file: common/identity-validation.yml",
    "- from-file: common/validation.yml",
    "- type: signing",
]
positions = []
for item in required_order:
    try:
        positions.append(module_lines.index(item))
    except ValueError:
        fail(f"{recipe}: missing ordered module {item}")
if positions != sorted(positions) or len(set(positions)) != len(positions):
    fail(f"{recipe}: identity, validation and signing order is unsafe")

identity = Path("recipes/common/identity.yml")
identity_source = identity.read_text(encoding="utf-8")
for field in [
    "  ID: barq",
    "  ID_LIKE: fedora",
    "  VERSION: 0.1 (Development)",
    "  RELEASE_TYPE: development",
    '  IMAGE_VERSION: "0.1"',
]:
    if field not in identity_source:
        fail(f"{identity}: missing required development identity {field!r}")

for match in re.finditer(r"^  - from-file: (.+)$", recipe_source, re.MULTILINE):
    target = recipe.parent / match.group(1).strip().strip('"')
    if not target.is_file():
        fail(f"{recipe}: missing from-file target {target}")

for path in sorted(Path("recipes/common").glob("*.yml")):
    count = len(re.findall(r"^type:\s+", path.read_text(encoding="utf-8"), re.MULTILINE))
    if count != 1:
        fail(f"{path}: expected exactly one module type, found {count}")

sha = re.compile(r"^[0-9a-f]{40}$")
for workflow in sorted(Path(".github/workflows").glob("*.yml")):
    for number, line in enumerate(workflow.read_text(encoding="utf-8").splitlines(), 1):
        stripped = line.strip()
        if not stripped.startswith("uses:"):
            continue
        value = stripped.removeprefix("uses:").strip()
        if value.startswith("./"):
            continue
        if "@" not in value or not sha.fullmatch(value.rsplit("@", 1)[1].split()[0]):
            fail(f"{workflow}:{number}: external action is not pinned to a full commit SHA")

png = Path("files/system/usr/share/wallpapers/Barq/contents/images/3840x2160.png")
png_data = png.read_bytes()
if png_data[:8] != b"\x89PNG\r\n\x1a\n" or png_data[12:16] != b"IHDR":
    fail(f"{png}: invalid PNG signature or IHDR")
width, height = struct.unpack(">II", png_data[16:24])
if (width, height) != (3840, 2160):
    fail(f"{png}: expected 3840x2160, found {width}x{height}")

qml = Path(
    "files/system/usr/share/plasma/look-and-feel/org.barq.desktop/contents/splash/Splash.qml"
)
qml_source = qml.read_text(encoding="utf-8")
for token in ["import QtQuick", "import org.kde.kirigami", "Rectangle {", "Barq OS"]:
    if token not in qml_source:
        fail(f"{qml}: missing required token {token!r}")
if qml_source.count("{") != qml_source.count("}"):
    fail(f"{qml}: unbalanced braces")

plymouth_script = Path("files/system/usr/share/plymouth/themes/barq/barq.script")
plymouth_source = plymouth_script.read_text(encoding="utf-8")
for callback in [
    "Plymouth.SetDisplayNormalFunction",
    "Plymouth.SetDisplayPasswordFunction",
    "Plymouth.SetDisplayQuestionFunction",
    "Plymouth.SetBootProgressFunction",
    "Plymouth.SetSystemUpdateFunction",
    "Plymouth.SetDisplayMessageFunction",
    "Plymouth.SetHideMessageFunction",
]:
    if callback not in plymouth_source:
        fail(f"{plymouth_script}: missing {callback}")
if plymouth_source.count("{") != plymouth_source.count("}"):
    fail(f"{plymouth_script}: unbalanced braces")

surface_roots = [
    Path("files/system/etc/issue"),
    Path("files/system/etc/xdg"),
    Path("files/system/usr/lib/plasmalogin"),
    Path("files/system/usr/share/applications"),
    Path("files/system/usr/share/color-schemes"),
    Path("files/system/usr/share/icons"),
    Path("files/system/usr/share/plasma"),
    Path("files/system/usr/share/plymouth"),
    Path("files/system/usr/share/wallpapers"),
]
surface_files: list[Path] = []
for root in surface_roots:
    if root.is_file():
        surface_files.append(root)
    elif root.is_dir():
        surface_files.extend(path for path in root.rglob("*") if path.is_file())

for path in surface_files:
    data = path.read_bytes()
    if b"\0" in data or path.suffix.lower() == ".png":
        continue
    lines = []
    for line in data.decode("utf-8").splitlines():
        stripped = line.lstrip()
        if stripped.startswith(("#", "//", "/*", "*")):
            continue
        lines.append(line)
    visible = "\n".join(lines)
    for forbidden in [
        "Fedora",
        "Kinoite",
        "SDDM",
        "Bazzite",
        "ChimeraOS",
        "Hatter",
        "BlueBuild",
    ]:
        if forbidden.casefold() in visible.casefold():
            fail(f"{path}: user-facing old/invalid identity {forbidden!r}")
    for invalid_name in ["BARQOS", "BarqOS", "BARQ OS", "Barq Linux"]:
        if invalid_name in visible:
            fail(f"{path}: invalid product spelling {invalid_name!r}")

print(
    "UTF-8, JSON, SVG, KConfig/INI, recipe order, workflow pins, artwork, "
    "QML, Plymouth and user-facing identity validation passed"
)
PY

git diff --check
printf 'All repository checks passed.\n'
