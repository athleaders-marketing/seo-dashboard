#!/usr/bin/env bash
# Local preview server. Hits the live Google Sheet, so what you see is what will deploy.
set -e
cd "$(dirname "$0")/.."
PORT=8000
echo "Serving on http://localhost:$PORT"
echo "Ctrl-C to stop"
echo ""
if command -v python3 >/dev/null 2>&1; then
  python3 -m http.server $PORT
elif command -v python >/dev/null 2>&1; then
  python -m SimpleHTTPServer $PORT
else
  echo "No Python found. Install python3 or use any other static server."
  exit 1
fi
