#!/usr/bin/env bash
set -euo pipefail
# Проверка через grep
if grep -q "pipeline {" Jenkinsfile 2>/dev/null || grep -q "pipeline{" Jenkinsfile 2>/dev/null; then
    echo "pipeline_block_ok"
else
    echo "pipeline_block_missing"
fi

if grep -q "agent " Jenkinsfile 2>/dev/null; then
    echo "agent_ok"
else
    echo "agent_missing"
fi

if grep -q "stages {" Jenkinsfile 2>/dev/null || grep -q "stages{" Jenkinsfile 2>/dev/null; then
    echo "stages_block_ok"
else
    echo "stages_block_missing"
fi

if grep -q "stage(" Jenkinsfile 2>/dev/null; then
    echo "stage_ok"
else
    echo "stage_missing"
fi

