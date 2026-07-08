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

perms = w.get("permissions", {})

if isinstance(perms, dict):
    print("contents_read_ok" if perms.get("contents") == "read" else f"contents_wrong: {perms.get('contents')}")
    print("id_token_write_ok" if perms.get("id-token") == "write" else f"id_token_wrong: {perms.get('id-token')}")
    print("packages_write_ok" if perms.get("packages") == "write" else f"packages_wrong: {perms.get('packages')}")
else:
    print(f"permissions_not_dict: {perms}")
PYEOF

