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
  while IFS= read -r -d '' script; do
    bash -n "$script"
  done

for executable in \
  files/system/usr/libexec/barq-os/image-smoke-test \
  files/system/usr/libexec/barq-os/open-gaming-interface \
  tests/repository.sh \
  tests/smoke.sh; do
  [[ -x "$executable" ]] || fail "$executable must be executable"
done

if git grep -nE '^(<<<<<<<|=======|>>>>>>>)' -- . ':!tests/repository.sh'; then
  fail "unresolved merge markers found"
fi

grep -RHnE '^  - from-file: ' recipes |
  while IFS=: read -r recipe line target; do
    target="${target#*from-file: }"
    target="${target%\"}"
    target="${target#\"}"
    [[ -f "$(dirname "$recipe")/$target" ]] || \
      fail "$recipe:$line references missing file $target"
  done

python3 - <<'PY'
from pathlib import Path
import configparser
import json
import re
import sys
import xml.etree.ElementTree as ET

for path in sorted(Path('.').rglob('*.json')):
    with path.open(encoding='utf-8') as stream:
        json.load(stream)

for path in sorted(Path('.').rglob('*.svg')):
    ET.parse(path)

desktop = Path('files/system/usr/share/applications/org.barq.Gaming.desktop')
parser = configparser.ConfigParser(interpolation=None, strict=True)
parser.optionxform = str
parser.read(desktop, encoding='utf-8')
entry = parser['Desktop Entry']
required = {
    'Type': 'Application',
    'Name': 'Barq Gaming',
    'Exec': '/usr/libexec/barq-os/open-gaming-interface',
    'Icon': 'barq-os',
}
for key, expected in required.items():
    if entry.get(key) != expected:
        print(f'{desktop}: expected {key}={expected!r}', file=sys.stderr)
        raise SystemExit(1)

sha = re.compile(r'^[0-9a-f]{40}$')
for workflow in sorted(Path('.github/workflows').glob('*.yml')):
    for number, line in enumerate(workflow.read_text(encoding='utf-8').splitlines(), 1):
        stripped = line.strip()
        if not stripped.startswith('uses:'):
            continue
        value = stripped.removeprefix('uses:').strip()
        if value.startswith('./'):
            continue
        if '@' not in value or not sha.fullmatch(value.rsplit('@', 1)[1].split()[0]):
            print(f'{workflow}:{number}: external action is not pinned to a full commit SHA', file=sys.stderr)
            raise SystemExit(1)

print('JSON, SVG, desktop entry and GitHub Action pin validation passed')
PY

git diff --check
printf 'All repository checks passed.\n'
