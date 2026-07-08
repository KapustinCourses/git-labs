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

# check permissions: {} at workflow level
perms = w.get("permissions", "NOT_SET")
if isinstance(perms, dict) and len(perms) == 0:
    print("permissions_empty_ok")
else:
    print(f"permissions_wrong: {perms}")

# check push trigger with branches: [main]
on_block = w.get("on") or w.get(True, {})
if isinstance(on_block, dict):
    push_block = on_block.get("push", {})
    if isinstance(push_block, dict):
        branches = push_block.get("branches", [])
        if "main" in branches:
            print("push_main_ok")
        else:
            print(f"push_main_missing: {branches}")
    else:
        print(f"push_not_dict: {push_block}")
else:
    print(f"on_block_wrong: {on_block}")
PYEOF

