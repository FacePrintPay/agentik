#!/data/data/com.termux/files/usr/bin/bash
echo "🌟 agentik"
curl -s http://localhost:3000/api/proxy > /dev/null && echo "✅ PATHOS"
echo "[agentik] $(date)" >> "/data/data/com.termux/files/home/sovereign_gtp/logs/agentik.log"
