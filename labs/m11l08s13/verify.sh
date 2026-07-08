#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/multi-arch.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

found_qemu = False
found_buildx = False
found_platforms = False

for jname, jdata in w.get("jobs", {}).items():
    for step in jdata.get("steps", []):
        uses = step.get("uses", "")
        if "setup-qemu-action@v3" in uses:
            found_qemu = True
        if "setup-buildx-action@v3" in uses:
            found_buildx = True
        if "build-push-action@v6" in uses:
            with_data = step.get("with", {})
            platforms = str(with_data.get("platforms", ""))
            if "amd64" in platforms and "arm64" in platforms:
                found_platforms = True

print("qemu_ok" if found_qemu else "qemu_missing")
print("buildx_ok" if found_buildx else "buildx_missing")
print("platforms_ok" if found_platforms else "platforms_missing")
PYEOF

