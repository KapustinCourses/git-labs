#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/custom-cache.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

found_cache = False
found_path = False
found_key = False
found_restore = False

for jname, jdata in w.get("jobs", {}).items():
    for step in jdata.get("steps", []):
        uses = step.get("uses", "")
        if "cache@v4" in uses:
            found_cache = True
            with_data = step.get("with", {})
            if with_data.get("path"):
                found_path = True
            if with_data.get("key"):
                found_key = True
            if with_data.get("restore-keys"):
                found_restore = True

print("cache_action_ok" if found_cache else "cache_action_missing")
print("path_ok" if found_path else "path_missing")
print("key_ok" if found_key else "key_missing")
print("restore_keys_ok" if found_restore else "restore_keys_missing")
PYEOF

