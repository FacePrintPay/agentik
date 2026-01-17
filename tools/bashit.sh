#!/bin/bash
# Wrapper for destructive commands requiring bioauth

echo "⚠️  DESTRUCTIVE COMMAND REQUIRES BIOMETRIC CONFIRMATION"
echo "Command: $@"
echo ""

# Confirm bioauth
bash tools/bioauth_gate.sh

echo ""
echo "Executing: $@"
exec "$@"