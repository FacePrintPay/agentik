#!/data/data/com.termux/files/usr/bin/bash
set -euo pipefail

need(){
  local bin="$1" pkgname="$2"
  if ! command -v "$bin" >/dev/null 2>&1; then
    if command -v pkg >/dev/null 2>&1; then
      pkg install -y "$pkgname" >/dev/null 2>&1
    else
      echo "Missing dependency: $bin" >&2
      exit 1
    fi
  fi
}

need git git
need python python
need curl curl

mkdir -p "$HOME/bin"
cp -f "$(dirname "$0")/thekre8tive" "$HOME/bin/thekre8tive"
chmod +x "$HOME/bin/thekre8tive"

if ! echo "$PATH" | tr ':' '\n' | grep -qx "$HOME/bin"; then
  export PATH="$HOME/bin:$PATH"
  if [ -f "$HOME/.bashrc" ] && ! grep -q 'export PATH="$HOME/bin:$PATH"' "$HOME/.bashrc"; then
    printf '\nexport PATH="$HOME/bin:$PATH"\n' >> "$HOME/.bashrc"
  fi
fi

echo "Installed: thekre8tive"
