#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/node-ci.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

found_setup_node = False
found_cache_npm = False

for jname, jdata in w.get("jobs", {}).items():
    for step in jdata.get("steps", []):
        uses = step.get("uses", "")
        if "setup-node@v6" in uses:
            found_setup_node = True
            with_data = step.get("with", {})
            cache_val = with_data.get("cache", "")
            if cache_val == "npm":
                found_cache_npm = True

if found_setup_node:
    print("setup_node_ok")
else:
    print("setup_node_missing")

if found_cache_npm:
    print("cache_npm_ok")
else:
    print("cache_npm_missing")
PYEOF

