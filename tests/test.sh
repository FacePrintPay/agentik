#!/data/data/com.termux/files/usr/bin/bash
echo "🧪 Testing: agentik"
# Test 1: Module exists
[ -f "$(dirname $0)/../run.sh" ] || [ -f "$(dirname $0)/../index.js" ] &&     echo "✅ Entry point exists" || echo "❌ No entry point"
# Test 2: PATHOS connection
curl -s --max-time 3 http://localhost:3000/api/proxy > /dev/null &&     echo "✅ PATHOS connected" || echo "⚠️  PATHOS offline"
echo "✅ agentik tests done"
