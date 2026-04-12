# AGENTIK™ (Agentik)

Local-first AGI agent orchestration platform — built to run **on your hardware**, keep data **on-device**, and ship automations fast.

**Repo:** `FacePrintPay/agentik`  
**UI:** `product/web/index.html`  
**Installer:** `install.sh`

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

```
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
```

---

## Quick Start (Termux)

### 1) Authenticate GitHub CLI
```bash
gh auth login
gh auth status
```

### 2) Run the ship script
```bash
cd ~/TheKre8tive
chmod +x ship-agentik.sh
./ship-agentik.sh
```

---

## Development

### Node (if present)
```bash
npm install
npm audit fix
npm update
npx eslint . --ext .js,.jsx,.ts,.tsx --fix
```

### Python (if present)
```bash
pip install -r requirements.txt
```

---

## Git Rules (YesQuid Pro)

- Conventional commits: `feat:`, `fix:`, `docs:`, `chore:`
- Branches: `main`, `develop`, `feature/*`, `fix/*`

---

## Embedded Repo Warning (Important)

If you see:
`warning: adding embedded git repository`

That means a folder inside your repo has its own `.git` directory.  
This repo ships with a guard that automatically:
- removes that folder from the index (if tracked)
- adds it to `.gitignore`

---

## Credits

Built by **CyGel** & **The Brickle Brothers**  
FacePrintPay / TheKre8tive
