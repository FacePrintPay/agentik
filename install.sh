#!/usr/bin/env bash
set -euo pipefail

echo "🌍 Installing AGENTIK™..."
echo "=========================="
echo ""

# Check dependencies
command -v git >/dev/null || { echo "❌ git required"; exit 1; }
command -v python >/dev/null || command -v python3 >/dev/null || { echo "❌ python required"; exit 1; }
command -v curl >/dev/null || { echo "❌ curl required"; exit 1; }

# Clone repo
REPO_DIR="$HOME/TheKre8tive"
if [ -d "$REPO_DIR" ]; then
    echo "✓ Updating existing installation..."
    cd "$REPO_DIR" && git pull --quiet
else
    echo "✓ Cloning repository..."
    git clone --quiet https://github.com/FacePrintPay/TheKre8tive.git "$REPO_DIR"
fi

# Install Python deps
echo "✓ Installing Python packages..."
python3 -m pip install --upgrade pip --quiet
python3 -m pip install fastapi uvicorn pydantic --quiet

# Setup CLI
mkdir -p "$HOME/.local/bin"
cp -f "$REPO_DIR/thekre8tive" "$HOME/.local/bin/thekre8tive"
chmod +x "$HOME/.local/bin/thekre8tive"

# Add to PATH
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    if [ -f "$HOME/.bashrc" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo "✓ Added to PATH (run: source ~/.bashrc)"
    fi
fi

echo ""
echo "╔════════════════════════════════════════╗"
echo "║  ✓ AGENTIK™ Installed Successfully    ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "Quick Start:"
echo "  1. source ~/.bashrc"
echo "  2. thekre8tive up"
echo "  3. Open: http://127.0.0.1:8765/index.html"
echo ""
echo "The revolution will not be hosted. 🌍"
