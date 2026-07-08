#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/deploy-envs.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

jobs = w.get("jobs", {})

# check staging
staging_job = jobs.get("deploy-staging", {})
env_staging = staging_job.get("environment", "")
if env_staging == "staging":
    print("staging_env_ok")
else:
    print(f"staging_env_wrong: {env_staging}")

# check production
prod_job = jobs.get("deploy-production", {})
env_prod = prod_job.get("environment", "")
if env_prod == "production":
    print("production_env_ok")
else:
    print(f"production_env_wrong: {env_prod}")

# check needs
needs = prod_job.get("needs", [])
if isinstance(needs, str):
    needs = [needs]
if "deploy-staging" in needs:
    print("needs_ok")
else:
    print(f"needs_missing: {needs}")
PYEOF

