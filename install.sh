#!/usr/bin/env bash
set -euo pipefail

echo "🌍 Installing AGENTIK™..."
echo "========================"
echo ""

command -v git >/dev/null || { echo "❌ git required"; exit 1; }
command -v python3 >/dev/null || { echo "❌ python3 required"; exit 1; }
command -v curl >/dev/null || { echo "❌ curl required"; exit 1; }

REPO_DIR="$HOME/agentik"

if [ -d "$REPO_DIR/.git" ]; then
  echo "✓ Updating existing install..."
  cd "$REPO_DIR" && git pull --quiet
else
  echo "✓ Cloning repository..."
  git clone --quiet https://github.com/FacePrintPay/agentik.git "$REPO_DIR"
fi

echo "✓ Installing Python packages (minimal)..."
python3 -m pip install --upgrade pip --quiet
python3 -m pip install fastapi uvicorn pydantic --quiet || true

echo ""
echo "✅ Installed."
echo "Open the UI:"
echo "  $REPO_DIR/product/web/index.html"
echo ""
echo "The revolution will not be hosted. 🌍"
