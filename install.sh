#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

say(){ printf "${GREEN}[TheKre8tive]${NC} %s\n" "$*"; }
warn(){ printf "${YELLOW}[WARNING]${NC} %s\n" "$*"; }
error(){ printf "${RED}[ERROR]${NC} %s\n" "$*"; exit 1; }

banner(){
  cat << 'EOF'
╔════════════════════════════════════════╗
║      TheKre8tive Installer v1.0       ║
║  Local-First AGI Agent Orchestration  ║
╚════════════════════════════════════════╝
EOF
}

need_pkg(){
  local bin="$1"
  local pkg="$2"
  
  if ! command -v "$bin" >/dev/null 2>&1; then
    if command -v pkg >/dev/null 2>&1; then
      say "Installing: $pkg"
      pkg install -y "$pkg" >/dev/null 2>&1
    else
      error "Missing dependency: $bin (cannot auto-install)"
    fi
  fi
}

clear
banner
echo ""

say "Checking dependencies..."
need_pkg git git
need_pkg python python
need_pkg curl curl
need_pkg jq jq
say "✓ Dependencies verified"
echo ""

say "Installing Python packages..."
python3 -m pip install --upgrade pip --quiet
python3 -m pip install fastapi uvicorn pydantic --quiet
say "✓ Python packages installed"
echo ""

say "Cloning repository..."
REPO_DIR="$HOME/TheKre8tive"
if [ -d "$REPO_DIR" ]; then
  warn "Repository already exists, updating..."
  cd "$REPO_DIR"
  git pull --quiet
else
  git clone --quiet https://github.com/FacePrintPay/TheKre8tive.git "$REPO_DIR"
  cd "$REPO_DIR"
fi
say "✓ Repository ready"
echo ""

say "Setting up CLI..."
mkdir -p "$HOME/.local/bin"
cp -f thekre8tive "$HOME/.local/bin/thekre8tive"
chmod +x "$HOME/.local/bin/thekre8tive"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  if [ -f "$HOME/.bashrc" ]; then
    echo '' >> "$HOME/.bashrc"
    echo '# TheKre8tive' >> "$HOME/.bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    say "Added to PATH (run: source ~/.bashrc)"
  fi
fi
say "✓ CLI installed"
echo ""

say "Setting up directories..."
mkdir -p "$HOME/tasks"/{incoming,processing,completed,failed}
mkdir -p "$HOME/outputs"/{appraisals,listings,finance,pr,outreach,income,bundles}
mkdir -p "$HOME/logs"/{orchestrator,agents,system}
say "✓ Directories created"
echo ""

echo "╔════════════════════════════════════════╗"
echo "║  ✓ TheKre8tive Installed Successfully ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "Quick Start:"
echo "  1. source ~/.bashrc"
echo "  2. thekre8tive up"
echo "  3. Open: http://127.0.0.1:8765/index.html"
echo ""
