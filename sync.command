#!/bin/bash
# Dupla kattintás: feltölti a legújabb változásokat a GitHubra (Vercel automatikusan újradeploy-ol).
cd "$(dirname "$0")"
git add -A
git commit -m "update" 2>/dev/null
git push
echo ""
echo "Kesz. Bezarhatod az ablakot."
