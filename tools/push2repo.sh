#!/bin/bash
# Git push with mandatory bioauth

echo "🚀 Preparing to push to repository..."
echo "This will create commits and push changes."

# Require bioauth
bash tools/bioauth_gate.sh

# Proceed with git operations
git add .
if [ $# -gt 0 ]; then
    git commit -m "$*"
else
    git commit -m "Automated commit via push2repo"
fi
git push

echo "✅ Push complete."