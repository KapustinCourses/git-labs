#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/dependabot.yml") as f:
        d = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

# check version
if d.get("version") == 2:
    print("version_2_ok")
else:
    print(f"version_wrong: {d.get('version')}")

# check updates
updates = d.get("updates", [])
found_ga = False
found_schedule = False
for update in updates:
    if update.get("package-ecosystem") == "github-actions":
        found_ga = True
        sched = update.get("schedule", {})
        if sched.get("interval") in ("daily", "weekly", "monthly"):
            found_schedule = True

print("github_actions_ecosystem_ok" if found_ga else "github_actions_ecosystem_missing")
print("schedule_ok" if found_schedule else "schedule_missing")
PYEOF

