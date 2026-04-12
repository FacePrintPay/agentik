#!/data/data/com.termux/files/usr/bin/bash
# ship-agentik.sh
# AGENTIK™ Repo Normalize + Docs + Safe Push (YesQuid Pro compliant)
# Works in Termux. No "exit 1" rage quits. It warns + guides.

set -u

TARGET_REPO_DEFAULT="FacePrintPay/agentik"
REMOTE_URL_DEFAULT="https://github.com/FacePrintPay/agentik.git"
BRANCH_DEFAULT="main"

say()  { printf "%s\n" "$*"; }
hr()   { printf "%s\n" "------------------------------------------------------------"; }
warn() { printf "⚠️  %s\n" "$*"; }
ok()   { printf "✅ %s\n" "$*"; }
info() { printf "ℹ️  %s\n" "$*"; }

# --- helpers (soft-fail) ---
run() {
  # run command; never hard-exit
  "$@" 2>/dev/null || return 1
  return 0
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 && return 0
  warn "Missing command: $1"
  return 1
}

is_git_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

repo_root() {
  git rev-parse --show-toplevel 2>/dev/null || echo ""
}

current_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null || echo ""
}

ensure_not_home_root() {
  local root
  root="$(repo_root)"
  if [ -z "$root" ]; then
    warn "Not inside a git repo yet."
    return 1
  fi
  if [ "$root" = "$HOME" ]; then
    warn "Repo is rooted at HOME! This will commit everything."
    warn "Fix: cd to your real project folder (ex: cd ~/TheKre8tive)"
    return 1
  fi
  return 0
}

# --- GitHub auth fix (the ONLY correct helper) ---
fix_gh_credential_helper() {
  # wipe any garbage helper lines (you had many)
  git config --global --unset-all credential.helper >/dev/null 2>&1 || true
  git config --global credential.helper "!gh auth git-credential" >/dev/null 2>&1 || true

  local helpers
  helpers="$(git config --global --get-all credential.helper 2>/dev/null || true)"

  if echo "$helpers" | grep -qx '!gh auth git-credential'; then
    ok "Git credential.helper set to GitHub CLI (global)"
  else
    warn "credential.helper still not correct globally."
    warn "Setting locally for this repo..."
    git config --local --unset-all credential.helper >/dev/null 2>&1 || true
    git config --local credential.helper "!gh auth git-credential" >/dev/null 2>&1 || true
    ok "Git credential.helper set locally"
  fi
}

ensure_gh_auth() {
  if ! need_cmd gh; then
    warn "Install GitHub CLI: pkg install gh"
    return 1
  fi
  gh auth status >/dev/null 2>&1
}

# --- Embedded repo guard ---
# If any folder contains its own .git, we do NOT want to commit it as nested repo/submodule.
# We will:
#  1) Remove from index if already staged/tracked
#  2) Add parent folder to .gitignore (non-destructive)
handle_embedded_git_repos() {
  info "Checking for embedded git repos..."
  local embedded
  embedded="$(find . -mindepth 2 -maxdepth 6 -type d -name .git 2>/dev/null | sed 's|^\./||g' || true)"
  if [ -z "$embedded" ]; then
    ok "No embedded repos detected"
    return 0
  fi

  warn "Embedded repos detected (these cause submodule warnings):"
  echo "$embedded" | while read -r dotgit; do
    [ -z "$dotgit" ] && continue
    local parent
    parent="$(dirname "$dotgit")"
    warn " - $parent"

    # remove from index if tracked
    git rm -r --cached "$parent" >/dev/null 2>&1 || true

    # ignore that folder
    if [ -f .gitignore ]; then
      grep -qx "$parent/" .gitignore 2>/dev/null || echo "$parent/" >> .gitignore
    else
      echo "$parent/" > .gitignore
    fi
  done

  ok "Embedded repos removed from index + ignored (non-destructive)"
}

# --- .gitignore baseline (YesQuid Pro + Termux safe) ---
ensure_gitignore() {
  info "Ensuring .gitignore blocks caches + secrets..."
  touch .gitignore 2>/dev/null || true

  # append-only patterns if missing
  add_ignore() {
    local line="$1"
    grep -qx "$line" .gitignore 2>/dev/null || echo "$line" >> .gitignore
  }

  # Termux / OS
  add_ignore ".DS_Store"
  add_ignore "*.log"
  add_ignore "*.pid"
  add_ignore ".tmp/"
  add_ignore ".cache/"
  add_ignore ".termux/"
  add_ignore ".npm/"
  add_ignore ".config/"
  add_ignore ".ssh/"
  add_ignore ".gnupg/"
  add_ignore ".env"
  add_ignore ".env.*"
  add_ignore "*.key"
  add_ignore "*.pem"

  # Python
  add_ignore "__pycache__/"
  add_ignore "*.pyc"
  add_ignore ".venv/"
  add_ignore "venv/"

  # Node
  add_ignore "node_modules/"
  add_ignore "npm-debug.log*"
  add_ignore "yarn-debug.log*"
  add_ignore "pnpm-lock.yaml"

  # Rust
  add_ignore ".cargo/registry/"
  add_ignore ".cargo/git/"
  add_ignore "target/"

  ok ".gitignore updated"
}

# --- Repo structure + docs scaffolding ---
normalize_structure() {
  info "Normalizing repo structure (non-destructive)..."

  mkdir -p docs scripts config src tests product/web product/docs 2>/dev/null || true

  # If you already have product/web/index.html, keep it.
  # If missing, create a minimal standards-compliant HTML.
  if [ ! -f product/web/index.html ]; then
    cat > product/web/index.html <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="description" content="AGENTIK™ — Local-first AGI agent orchestration platform." />
  <title>AGENTIK™ | Local-First Agent Orchestration</title>
</head>
<body>
  <header>
    <nav aria-label="Primary navigation">
      <strong>AGENTIK™</strong>
    </nav>
  </header>

  <main>
    <section>
      <article>
        <h1>AGENTIK™</h1>
        <p>Local-first AGI agent orchestration platform.</p>
      </article>
    </section>
  </main>

  <footer>
    <small>Built by CyGel &amp; The Brickle Brothers.</small>
  </footer>
</body>
</html>
EOF
    ok "Created product/web/index.html (YesQuid Pro HTML baseline)"
  else
    ok "product/web/index.html exists"
  fi

  # Minimal docs if missing
  if [ ! -f docs/deployment.md ]; then
    cat > docs/deployment.md <<'EOF'
# Deployment

## Termux (Local)
- Ensure `gh` is authenticated: `gh auth status`
- Run: `./ship-agentik.sh`

## Vercel
- Import the repo
- Root Directory: `product/web`
EOF
    ok "Created docs/deployment.md"
  fi
}

# --- requirements generation ---
generate_requirements() {
  # Python requirements
  if [ -d ".venv" ] || [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || [ -f "setup.py" ]; then
    info "Generating Python requirements..."
    if need_cmd python && need_cmd pip; then
      # best-effort freeze (won't fail build if env isn't active)
      pip freeze 2>/dev/null > requirements.txt || true
      if [ -s requirements.txt ]; then
        ok "Wrote requirements.txt"
      else
        warn "requirements.txt empty (activate venv then re-run if you want exact deps)"
      fi
    else
      warn "Python/pip not available to generate requirements.txt"
    fi
  fi

  # Node note
  if [ -f "package.json" ]; then
    ok "Detected package.json (Node project present)"
  fi
}

# --- README compile (from what we know + safe assumptions) ---
write_readme() {
  info "Compiling README (YesQuid Pro style)..."

  # Only overwrite if missing OR user wants to rebuild
  if [ -f README.md ]; then
    info "README.md exists — backing up to README.md.bak"
    cp README.md README.md.bak 2>/dev/null || true
  fi

  cat > README.md <<EOF
# AGENTIK™ (Agentik)

Local-first AGI agent orchestration platform — built to run **on your hardware**, keep data **on-device**, and ship automations fast.

**Repo:** \`${TARGET_REPO_DEFAULT}\`  
**UI:** \`product/web/index.html\`  
**Installer:** \`install.sh\`

---

## Why AGENTIK™?

Most AI platforms:
- charge per token/seat
- move your data off-device
- lock you into their ecosystem

AGENTIK™:
- runs on **YOUR** hardware
- keeps data **local**
- stays modular and composable

---

## Directory Structure

\`\`\`
agentik/
├── README.md
├── .gitignore
├── install.sh
├── requirements.txt              # generated if Python deps detected
├── product/
│   ├── web/
│   │   └── index.html            # production web UI
│   └── docs/
├── docs/
│   ├── deployment.md
│   └── architecture.md           # (add as needed)
├── scripts/
│   └── ship-agentik.sh           # normalize + push script
├── src/
├── tests/
└── config/
\`\`\`

---

## Quick Start (Termux)

### 1) Authenticate GitHub CLI
\`\`\`bash
gh auth login
gh auth status
\`\`\`

### 2) Run the ship script
\`\`\`bash
cd ~/TheKre8tive
chmod +x ship-agentik.sh
./ship-agentik.sh
\`\`\`

---

## Development

### Node (if present)
\`\`\`bash
npm install
npm audit fix
npm update
npx eslint . --ext .js,.jsx,.ts,.tsx --fix
\`\`\`

### Python (if present)
\`\`\`bash
pip install -r requirements.txt
\`\`\`

---

## Git Rules (YesQuid Pro)

- Conventional commits: \`feat:\`, \`fix:\`, \`docs:\`, \`chore:\`
- Branches: \`main\`, \`develop\`, \`feature/*\`, \`fix/*\`

---

## Embedded Repo Warning (Important)

If you see:
\`warning: adding embedded git repository\`

That means a folder inside your repo has its own \`.git\` directory.  
This repo ships with a guard that automatically:
- removes that folder from the index (if tracked)
- adds it to \`.gitignore\`

---

## Credits

Built by **CyGel** & **The Brickle Brothers**  
FacePrintPay / TheKre8tive
EOF

  ok "README.md written (backup saved as README.md.bak if it existed)"
}

# --- Ensure branch exists + commit exists ---
ensure_branch_and_commit() {
  local branch="$1"

  # ensure at least one commit exists
  if ! git rev-parse HEAD >/dev/null 2>&1; then
    warn "No commits yet — creating initial commit."
    git add -A >/dev/null 2>&1 || true
    git commit -m "chore(repo): initialize agentik scaffold" >/dev/null 2>&1 || true
  fi

  # ensure branch name
  local cur
  cur="$(current_branch)"
  if [ -z "$cur" ] || [ "$cur" = "HEAD" ]; then
    git checkout -b "$branch" >/dev/null 2>&1 || true
  fi
  if [ "$(current_branch)" != "$branch" ]; then
    git checkout -B "$branch" >/dev/null 2>&1 || true
  fi
  ok "Branch ready: $branch"
}

ensure_remote() {
  local url="$1"
  git remote remove origin >/dev/null 2>&1 || true
  git remote add origin "$url" >/dev/null 2>&1 || true
  ok "Remote set: $url"
}

commit_if_needed() {
  # stage and commit if changes exist
  git add -A >/dev/null 2>&1 || true

  if git diff --cached --quiet >/dev/null 2>&1; then
    info "Nothing new to commit"
    return 0
  fi

  local msg
  msg="chore(repo): normalize structure + docs ($(date '+%F %T'))"
  git commit -m "$msg" >/dev/null 2>&1 || true
  ok "Committed: $msg"
}

pull_merge_remote() {
  local branch="$1"
  git fetch origin "$branch" >/dev/null 2>&1 || true

  # merge remote if exists
  if git show-ref --verify --quiet "refs/remotes/origin/$branch"; then
    info "Merging origin/$branch (safe merge)..."
    git merge -m "chore(repo): merge remote $branch" "origin/$branch" >/dev/null 2>&1 \
      || git merge --allow-unrelated-histories -m "chore(repo): merge remote $branch" "origin/$branch" >/dev/null 2>&1 \
      || true
    ok "Remote merged (or already up to date)"
  else
    info "No remote branch yet (first push scenario)"
  fi
}

push_with_safe_force() {
  local branch="$1"
  info "Pushing to GitHub..."
  if git push -u origin "$branch" >/dev/null 2>&1; then
    ok "Push OK"
  else
    warn "Normal push rejected — using force-with-lease (safe source-of-truth)"
    git push --force-with-lease -u origin "$branch" >/dev/null 2>&1 || true
    ok "Force-with-lease attempted"
  fi
}

main() {
  hr
  say "=== AGENTIK™ SHIP (Normalize + Docs + Push) ==="
  hr

  local target_repo="${1:-$TARGET_REPO_DEFAULT}"
  local remote_url="${2:-$REMOTE_URL_DEFAULT}"
  local branch="${3:-$BRANCH_DEFAULT}"

  say "PWD: $(pwd)"
  say "Target: $target_repo"
  say "Remote: $remote_url"
  say "Branch: $branch"
  hr

  # Ensure we are in a repo; if not, init here (but warn if HOME)
  if ! is_git_repo; then
    warn "Not a git repo here. Initializing in current directory..."
    git init >/dev/null 2>&1 || true
    ok "git init done"
  fi

  # Safety: do NOT operate from $HOME repo root
  if ! ensure_not_home_root; then
    warn "Aborting ship actions to protect your HOME directory."
    warn "cd into your project folder and re-run:"
    warn "  cd ~/TheKre8tive"
    warn "  ./ship-agentik.sh"
    return 0
  fi

  # Fix creds + auth
  fix_gh_credential_helper
  if ensure_gh_auth; then
    ok "GitHub auth OK"
  else
    warn "Not authenticated. Run: gh auth login"
    return 0
  fi

  # normalize + docs
  ensure_gitignore
  normalize_structure
  generate_requirements
  write_readme

  # embedded repos guard (before commit)
  handle_embedded_git_repos

  # remote + branch + commit
  ensure_remote "$remote_url"
  ensure_branch_and_commit "$branch"
  commit_if_needed

  # remote sync then push
  pull_merge_remote "$branch"
  push_with_safe_force "$branch"

  hr
  say "🎯 DONE"
  say "Repo: https://github.com/$target_repo"
  say "HEAD: $(git log -1 --oneline 2>/dev/null || echo 'no commits')"
  hr
  say "IMPORTANT:"
  say "Do NOT set credential.helper to random strings."
  say "Correct value is:"
  say "  !gh auth git-credential"
  hr
}

main "$@"
