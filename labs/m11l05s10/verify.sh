#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/main.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

found_uses = False
found_with = False

for jname, jdata in w.get("jobs", {}).items():
    uses = jdata.get("uses", "")
    if "template.yml" in uses:
        found_uses = True
        if jdata.get("with"):
            found_with = True

print("uses_template_ok" if found_uses else "uses_template_missing")
print("with_ok" if found_with else "with_missing")
PYEOF

