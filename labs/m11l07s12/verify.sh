#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys, re

sha_pattern = re.compile(r'^[a-f0-9]{40}$')

try:
    with open(".github/workflows/pinned.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

all_sha = True
uses_count = 0

for jname, jdata in w.get("jobs", {}).items():
    for step in jdata.get("steps", []):
        uses = step.get("uses", "")
        if uses:
            uses_count += 1
            ref = uses.split("@")[1] if "@" in uses else "?"
            if not sha_pattern.match(ref):
                print(f"not_sha: {uses}")
                all_sha = False

if uses_count == 0:
    print("no_uses_found")
elif all_sha:
    print("all_pinned_by_sha")
PYEOF

