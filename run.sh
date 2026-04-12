#!/data/data/com.termux/files/usr/bin/bash
echo "🌟 Agentik"
curl -s http://localhost:3000/api/proxy > /dev/null && echo "✅ PATHOS"
echo "[Agentik] $(date)" >> "/data/data/com.termux/files/home/sovereign_gtp/logs/Agentik.log"
