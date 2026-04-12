#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

TARGET_REPO="${TARGET_REPO:-FacePrintPay/agentik}"
REMOTE_URL="https://github.com/${TARGET_REPO}.git"
BRANCH="${BRANCH:-main}"

say() { echo ">>> $*"; }
die() { echo "❌ $*"; return 1; }

# Must run inside a repo folder (NOT $HOME)
if [ ! -d ".git" ]; then
  die "Not inside a git repo. cd into your repo folder and run again."
fi

if [ "$(pwd)" = "$HOME" ]; then
  die "Refusing to run in \$HOME. That would track personal files."
fi

# Fix credential helper (ONLY correct value)
git config --global --unset-all credential.helper >/dev/null 2>&1 || true
git config --global credential.helper "!gh auth git-credential" >/dev/null 2>&1 || true

# Verify auth
if ! gh auth status >/dev/null 2>&1; then
  die "GitHub CLI not authenticated. Run: gh auth login"
fi
say "✅ GitHub auth OK"

# .gitignore (block caches + secrets + rust registry + termux noise)
touch .gitignore
cat >> .gitignore <<'EOF'

# Termux / OS
.DS_Store
*.log
*.pid
.tmp/

# Python
__pycache__/
*.pyc
.venv/
.env

# Node
node_modules/
npm-debug.log*
yarn-debug.log*

# Rust (DO NOT COMMIT REGISTRY)
.cargo/registry/
.cargo/git/
target/

# Caches
.cache/
EOF

# Embedded repo guard: remove any nested .git folders from index (no submodules)
say "🧼 Checking for embedded git repos..."
EMBEDDED="$(find . -mindepth 2 -maxdepth 6 -type d -name .git 2>/dev/null | head -n 50 || true)"
if [ -n "$EMBEDDED" ]; then
  echo "⚠️ Found embedded repos:"
  echo "$EMBEDDED" | sed 's|^\./||g'

  # Ignore parent folders
  while read -r gitdir; do
    parent="$(dirname "$gitdir")"
    echo "$parent/" >> .gitignore
    # If already tracked, untrack safely
    git rm -r --cached "$parent" >/dev/null 2>&1 || true
  done <<< "$EMBEDDED"

  say "✅ Embedded repos ignored (and untracked if needed)"
else
  say "✅ No embedded repos detected"
fi

# Ensure docs exist
mkdir -p docs product/docs scripts >/dev/null 2>&1 || true
if [ ! -f "docs/deployment.md" ]; then
  cat > "docs/deployment.md" <<'MD'
# Deployment

## Termux
- Install dependencies: pkg install git gh python
- Authenticate: gh auth login
- Ship: ./scripts/ship-agentik.sh

## Web UI
Open: product/web/index.html

## Notes
- Keep repo local-first.
- Do not commit caches, secrets, or nested repos.
MD
fi

# Ensure remote is correct
git remote remove origin >/dev/null 2>&1 || true
git remote add origin "$REMOTE_URL"
say "✅ Remote set: $REMOTE_URL"

# Ensure branch exists
if ! git rev-parse --verify "$BRANCH" >/dev/null 2>&1; then
  git checkout -b "$BRANCH" >/dev/null 2>&1 || true
fi

# Commit if needed
git add -A
if git diff --cached --quiet; then
  say "ℹ️ Nothing new to commit"
else
  MSG="chore(repo): ship normalize + docs ($(date '+%F %T'))"
  git commit -m "$MSG" >/dev/null 2>&1 || true
  say "✅ Committed: $MSG"
fi

# Merge remote safely, then push (normal then force-with-lease)
git fetch origin "$BRANCH" >/dev/null 2>&1 || true
git merge -m "merge: origin/$BRANCH" "origin/$BRANCH" >/dev/null 2>&1 || \
git merge --allow-unrelated-histories -m "merge: origin/$BRANCH" "origin/$BRANCH" >/dev/null 2>&1 || true

if git push -u origin "$BRANCH"; then
  say "✅ Push OK"
else
  say "⚠️ Push rejected — using force-with-lease"
  git push --force-with-lease -u origin "$BRANCH"
  say "✅ Force-with-lease OK"
fi

say "🎯 DONE"
say "Repo: https://github.com/${TARGET_REPO}"
say "HEAD: $(git log -1 --oneline)"
say "IMPORTANT: credential.helper MUST be:"
say "  !gh auth git-credential"
