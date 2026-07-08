#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".gitlab-ci.yml") as f:
        c = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

# check stages
stages = c.get("stages", [])
if "build" in stages and "deploy" in stages:
    print("stages_ok")
else:
    print(f"stages_wrong: {stages}")

# find deploy job
deploy_job = None
for key, val in c.items():
    if isinstance(val, dict) and val.get("stage") == "deploy":
        deploy_job = val
        print("deploy_job_ok")
        break

if not deploy_job:
    print("deploy_job_missing")
else:
    rules = deploy_job.get("rules", [])
    if rules:
        print("rules_ok")
        # check for main condition
        for rule in rules:
            if isinstance(rule, dict):
                cond = str(rule.get("if", ""))
                if "main" in cond:
                    print("main_condition_ok")
                    break
        else:
            print("main_condition_missing")
    else:
        print("rules_missing")
PYEOF

