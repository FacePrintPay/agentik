# AGENTIK™

Local-first agent orchestration platform — built to run on your hardware, keep data on-device, and ship automations fast.

Repository: FacePrintPay/agentik  
Web UI: product/web/index.html  
Installer: install.sh

---

## Why AGENTIK™?

Most AI platforms:
- charge per token / per seat
- move your data off-device
- lock you into proprietary ecosystems

AGENTIK™:
- runs on your hardware
- keeps data local-first
- stays modular, composable, scriptable

> Philosophy: You own your compute. You own your data. You own your AI.

---

## Directory Structure

agentik/
├── README.md
├── .gitignore
├── install.sh
├── product/
│   ├── web/
│   │   └── index.html
│   └── docs/
├── docs/
│   └── deployment.md
├── scripts/
│   └── ship-agentik.sh
├── src/
├── tests/
└── config/

---

## Quick Start (Termux)

1) Authenticate GitHub CLI

gh auth login  
gh auth status

2) Ship the repo (normalize + docs + push)

cd ~/TheKre8tive  
chmod +x scripts/ship-agentik.sh  
./scripts/ship-agentik.sh

---

## Development

Node.js (if present)

npm install  
npm audit fix  
npm update  
npx eslint . --ext .js,.jsx,.ts,.tsx --fix

Python (if present)

pip install -r requirements.txt

---

## Git Rules (YesQuid Pro)

Conventional commits: feat:, fix:, docs:, chore:  
Branches: main, develop, feature/*, fix/*

---

## Embedded Repo Warning (Important)

If you see:

warning: adding embedded git repository

It means a folder inside this repo contains its own .git directory.

This repo ships with a guard that:
- removes that folder from the Git index (if tracked)
- ignores that path so it won't become a submodule by accident

Manual fix:

git rm -r --cached <folder>

---

## Credits

Built by CyGel & The Brickle Brothers  
FacePrintPay / TheKre8tive
