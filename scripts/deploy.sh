#!/usr/bin/env bash
# Commit all changes and push to main.
set -e
cd "$(dirname "$0")/.."

if [ -z "$1" ]; then
  echo "Usage: ./scripts/deploy.sh \"commit message\""
  exit 1
fi

if git diff --quiet && git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

echo "Changes to be committed:"
git status --short
echo ""
read -p "Proceed? (y/N) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Cancelled."
  exit 0
fi

git add -A
git commit -m "$1"
git push origin main

echo ""
echo "Pushed. Live site should reflect within a minute or two."
