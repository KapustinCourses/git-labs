#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/release.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

c = w.get("concurrency", {})

if isinstance(c, dict):
    group = c.get("group", "")
    if group:
        print("concurrency_group_ok")
    else:
        print("concurrency_group_missing")

    cip = c.get("cancel-in-progress", None)
    if cip is False:
        print("cancel_false_ok")
    else:
        print(f"cancel_wrong: {cip}")
else:
    print(f"concurrency_not_dict: {c}")
PYEOF

