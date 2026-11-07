#!/usr/bin/env bash
# Headless overnight planning run. Plan only: no Bash granted, hard turn limit.
set -euo pipefail
cd "$(dirname "$0")"
claude -p "Read context/BRIEF.md and execute it fully." \
  --model sonnet \
  --allowedTools "Read,Write,Edit,Glob,Grep,WebSearch,WebFetch,Task" \
  --max-turns 200 \
  2>&1 | tee overnight.log
echo "Done. Open docs/PLAN.md"
