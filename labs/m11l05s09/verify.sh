#!/usr/bin/env bash
set -euo pipefail
python3 - << 'PYEOF'
import yaml, sys

try:
    with open(".github/workflows/template.yml") as f:
        w = yaml.safe_load(f)
except Exception as e:
    print(f"yaml_error: {e}")
    sys.exit(0)

# YAML: 'on' может парситься как True (boolean)
on_block = w.get("on") or w.get(True, {})

if isinstance(on_block, dict) and "workflow_call" in on_block:
    print("workflow_call_ok")
    wc = on_block["workflow_call"]
    if isinstance(wc, dict) and "inputs" in wc:
        print("inputs_ok")
        inputs = wc["inputs"]
        if isinstance(inputs, dict) and "node-version" in inputs:
            print("node_version_input_ok")
        else:
            print(f"node_version_missing: {list(inputs.keys()) if isinstance(inputs, dict) else inputs}")
    else:
        print(f"inputs_missing in workflow_call: {wc}")
else:
    print(f"workflow_call_missing: on_block keys = {list(on_block.keys()) if isinstance(on_block, dict) else on_block}")
PYEOF

