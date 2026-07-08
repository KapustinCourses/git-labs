#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/docker-build.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

found_buildx = False
found_login = False
found_login_ghcr = False
found_build_push = False

for jname, jdata in w.get("jobs", {}).items():
    for step in jdata.get("steps", []):
        uses = step.get("uses", "")
        if "setup-buildx-action@v3" in uses:
            found_buildx = True
        if "login-action@v3" in uses:
            found_login = True
            with_data = step.get("with", {})
            if with_data.get("registry") == "ghcr.io":
                found_login_ghcr = True
        if "build-push-action@v6" in uses:
            found_build_push = True

print("buildx_ok" if found_buildx else "buildx_missing")
print("login_ok" if found_login else "login_missing")
print("login_ghcr_ok" if found_login_ghcr else "login_ghcr_missing")
print("build_push_ok" if found_build_push else "build_push_missing")
PYEOF

