# 🌍 TheKre8tive (AGENTIK)

**Local-first AGI agent orchestration platform.**

Run a complete autonomous AI agent swarm on your phone. Offline. No cloud. No tracking. No rent.

```bash
curl -fsSL https://raw.githubusercontent.com/FacePrintPay/TheKre8tive/main/install.sh | bash
```

[![License: Proprietary](https://img.shields.io/badge/License-Proprietary-red.svg)](LICENSE)
[![Platform: Termux](https://img.shields.io/badge/Platform-Termux%20%7C%20Linux-blue.svg)](https://termux.dev)
[![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-green.svg)](https://github.com/FacePrintPay/TheKre8tive/releases)

---

## 🚀 Quick Start

### One-Line Install
```bash
curl -fsSL https://raw.githubusercontent.com/FacePrintPay/TheKre8tive/main/install.sh | bash
```

### Start All Services
```bash
thekre8tive up
```

### Open Dashboard
Navigate to: `http://127.0.0.1:8765/index.html`

**That's it.** You now have a full AGI agent platform running locally.

---

## 🎯 What Is This?

**TheKre8tive** (AGENTIK) is a complete full-stack AGI agent orchestration platform that runs **entirely locally**:

- **7 specialized AI agents** (valuation, market research, finance, PR, outreach, income scanning, bundling)
- **Real-time web dashboard** with live monitoring
- **Task queue management** with concurrent execution
- **API layer** for programmatic control (FastAPI)
- **Health monitoring** with auto-restart
- **Zero dependencies** on external cloud services (except AI model APIs)

**Built for:** Termux (Android), Linux, macOS  
**Tech Stack:** Python, FastAPI, Bash, HTML/JS  
**Philosophy:** You own your compute. You own your data. You own your AI.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────┐
│      WEB UI (Live Dashboard)            │
│      http://127.0.0.1:8765              │
└───────────────┬─────────────────────────┘
                │
                ↓ HTTP/JSON
                │
┌───────────────┴─────────────────────────┐
│         API LAYER                       │
│  ┌──────────────┐  ┌─────────────────┐ │
│  │ Keys API     │  │ Swarm API       │ │
│  │ (port 8000)  │  │ (port 8001)     │ │
│  └──────────────┘  └─────────────────┘ │
└───────────────┬─────────────────────────┘
                │
                ↓ File System (JSON)
                │
┌───────────────┴─────────────────────────┐
│    ORCHESTRATOR (Background Daemon)     │
└───────────────┬─────────────────────────┘
                │
                ↓ Dispatch
                │
┌───────────────┴─────────────────────────┐
│           7 AGENT LAYER                 │
│  • agent_valuation  (appraisals)        │
│  • agent_market     (listings)          │
│  • agent_finance    (funding)           │
│  • agent_pr         (pitches)           │
│  • agent_outreach   (emails)            │
│  • agent_income     (opportunities)     │
│  • agent_bundle     (aggregation)       │
└─────────────────────────────────────────┘
```

---

## 💡 Features

- ✅ **Full-stack web UI** with real-time monitoring
- ✅ **RESTful APIs** (FastAPI) for programmatic control
- ✅ **7 specialized agents** ready out-of-the-box
- ✅ **Task queue system** with JSON-based tasks
- ✅ **Concurrent execution** (configurable parallelism)
- ✅ **Health monitoring** with auto-restart
- ✅ **Comprehensive logging**

---

## 📦 What's Included

```
TheKre8tive/
├── install.sh                    # One-line installer
├── thekre8tive                   # Main control script
├── README.md                     # This file
├── LICENSE                       # Proprietary license
├── docs/                         # Documentation
├── src/
│   ├── api/                      # FastAPI implementations
│   ├── orchestrator/             # Task orchestrator
│   ├── agents/                   # Agent definitions
│   ├── monitoring/               # Health monitoring
│   └── web/                      # Dashboard UI
├── config/                       # Configuration
└── tests/                        # Test suite
```

---

## 🎮 Usage

### CLI Commands
```bash
thekre8tive up          # Start all services
thekre8tive down        # Stop all services
thekre8tive restart     # Restart all services
thekre8tive status      # Check service health
thekre8tive logs        # View service logs
```

### Web Dashboard
Open: `http://127.0.0.1:8765/index.html`

### API Usage
```bash
# Create task
curl -X POST http://127.0.0.1:8001/swarm/task \
  -H "Content-Type: application/json" \
  -d '{"agent": "valuation", "task_type": "appraisal", "description": "Appraise coin", "priority": "high"}'

# Check status
curl http://127.0.0.1:8001/swarm/status | jq .
```

---

## 📄 License

**Copyright © 2025 FacePrintPay / TheKre8tive**

Proprietary software. See [LICENSE](LICENSE) for details.

---

## 🙏 Credits

**Built by:** FacePrintPay Team  
**Powered by:** Claude (Anthropic), FastAPI, Python, Bash

---

## 📞 Contact

- 🌐 **Website:** https://faceprintpay.com
- 🐦 **Twitter:** [@FacePrintPay](https://twitter.com/FacePrintPay)
- 📧 **Email:** hello@faceprintpay.com

---

**The revolution will not be hosted.** 🌍
