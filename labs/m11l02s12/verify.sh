#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/docker.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

found_buildx = False
found_build_push = False
found_cache_from = False
found_cache_to = False

for jname, jdata in w.get("jobs", {}).items():
    for step in jdata.get("steps", []):
        uses = step.get("uses", "")
        if "setup-buildx-action@v3" in uses:
            found_buildx = True
        if "build-push-action@v6" in uses:
            found_build_push = True
            with_data = step.get("with", {})
            cf = str(with_data.get("cache-from", ""))
            ct = str(with_data.get("cache-to", ""))
            if "type=gha" in cf:
                found_cache_from = True
            if "type=gha" in ct:
                found_cache_to = True

print("buildx_ok" if found_buildx else "buildx_missing")
print("build_push_ok" if found_build_push else "build_push_missing")
print("cache_from_ok" if found_cache_from else "cache_from_missing")
print("cache_to_ok" if found_cache_to else "cache_to_missing")
PYEOF

