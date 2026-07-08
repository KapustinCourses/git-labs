#!/usr/bin/env bash
set -euo pipefail
command -v git >/dev/null 2>&1 || (apk add --quiet git 2>/dev/null || apt-get install -y -qq git >/dev/null 2>&1)
git config --global user.email "student@stepik.local"
git config --global user.name  "Student"
git config --global init.defaultBranch main

git init -q

# Alice пишет первые 3 строки
cat > core.py << 'PYEOF'
def init():
    pass
def start():
PYEOF
git add core.py
GIT_AUTHOR_NAME="Alice" GIT_AUTHOR_EMAIL="alice@example.com" \
GIT_COMMITTER_NAME="Alice" GIT_COMMITTER_EMAIL="alice@example.com" \
git commit -q -m "Add core init"

# Bob пишет строки 4–6
cat >> core.py << 'PYEOF'
    return True
def process(x):
    return x * 2
PYEOF
git add core.py
GIT_AUTHOR_NAME="Bob" GIT_AUTHOR_EMAIL="bob@example.com" \
GIT_COMMITTER_NAME="Bob" GIT_COMMITTER_EMAIL="bob@example.com" \
git commit -q -m "Add core process"

# Charlie дописывает строки 7–8
cat >> core.py << 'PYEOF'
def stop():
    pass
PYEOF
git add core.py
GIT_AUTHOR_NAME="Charlie" GIT_AUTHOR_EMAIL="charlie@example.com" \
GIT_COMMITTER_NAME="Charlie" GIT_COMMITTER_EMAIL="charlie@example.com" \
git commit -q -m "Add core stop"
